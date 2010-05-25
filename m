Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0EYCRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 22:17:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57344 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0EYCRB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 22:17:01 -0400
MIME-Version: 1.0
Message-ID: <c5c17e83-a21c-4360-a201-3bb865062961@default>
Date: Mon, 24 May 2010 19:15:59 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: chris.mason@oracle.com, akpm@linux-foundation.org, adilger@sun.com,
       tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com, matthew@wil.cx,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
       jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com,
       npiggin@suse.de, dave.mccracken@oracle.com, riel@redhat.com
Subject: RE: Cleancache [PATCH 2/7] (was Transcendent Memory): core files
References: <20100422132809.GA27302@ca-server1.us.oracle.com
 20100514231815.GY30031@ZenIV.linux.org.uk
 1b84523f-a7df-4d6a-870f-b684bd012230@default>
In-Reply-To: <1b84523f-a7df-4d6a-870f-b684bd012230@default>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BFB3303.01C5:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The third one is pgoff_t; again, use sane types, _if_ you actually
> want
> > the argument #3 at all - it can be derived from struct page you are
> > passing there as well.
> 
> I thought it best to declare the _ops so that the struct page
> is opaque to the "backend" (driver).  The kernel-side ("frontend")
> defines the handle and ensures coherency, so the backend shouldn't
> be allowed to derive or muck with the three-tuple passed by the
> kernel. In the existing (Xen tmem) driver, the only operation
> performed on the struct page parameter is page_to_pfn().  OTOH,
> I could go one step further and pass a pfn_t instead of a
> struct page, since it is really only the physical page frame that
> the backend needs to know about and (synchronously) read/write from/to.
> 
> Thoughts?

Silly me.  pfn_t is a Xen/KVM type not otherwise used in the
kernel AFAICT.  Please ignore...

