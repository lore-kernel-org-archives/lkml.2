Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917Ab2EUPF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:05:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24518 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2EUPF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:05:28 -0400
MIME-Version: 1.0
Message-ID: <ee168801-3f7e-49ec-9a6e-14b6a4bc6a5f@default>
Date: Mon, 21 May 2012 08:04:00 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, Nitin Gupta <ngupta@vflare.org>
Subject: RE: [PATCH] zsmalloc: use unsigned long instead of void *
References: <1337567013-4741-1-git-send-email-minchan@kernel.org>
 <4FBA4EE2.8050308@linux.vnet.ibm.com>
In-Reply-To: <4FBA4EE2.8050308@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH] zsmalloc: use unsigned long instead of void *
> 
> On 05/20/2012 09:23 PM, Minchan Kim wrote:
> 
> > We should use unsigned long as handle instead of void * to avoid any
> > confusion. Without this, users may just treat zs_malloc return value as
> > a pointer and try to deference it.
> 
> I wouldn't have agreed with you about the need for this change as people
> should understand a void * to be the address of some data with unknown
> structure.
> 
> However, I recently discussed with Dan regarding his RAMster project
> where he assumed that the void * would be an address, and as such,
> 4-byte aligned.  So he has masked two bits into the two LSBs of the
> handle for RAMster, which doesn't work with zsmalloc since the handle is
> not an address.
> 
> So really we do need to convey as explicitly as possible to the user
> that the handle is an _opaque_ value about which no assumption can be made.

Someone once said: "Opaque is a computer science term and has no
meaning in system software and computer engineering."  ;-)
