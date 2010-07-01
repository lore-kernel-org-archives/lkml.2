Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0GAUl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:41:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:33921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab0GAUl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:41:27 -0400
Date: Fri, 2 Jul 2010 06:41:08 +1000
From: Neil Brown <neilb@suse.de>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100702064108.64034561@notabene.brown>
In-Reply-To: <871vbn2mk9.fsf@linux.vnet.ibm.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<871vbn2mk9.fsf@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010 21:58:54 +0530
"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Tue, 15 Jun 2010 22:42:50 +0530, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> Hi Al,
> 
> Any chance of getting this reviewed/merged in the next merge window ?

 My own opinion of the patchset is that the code itself is fine,
 however there is one part of the interface that bothers me.

 I think that it is a little ugly that filesystem uuid extraction is so
 closely tied to filehandle manipulation.  They are certainly related, and we
 certainly need to be able to get the filesystem uuid directly from the
 filesystem, but given that filehandle -> fd mapping doesn't (and shouldn't)
 use the uuid, the fact that fd/name -> filehandle mapping does return the
 uuid looks like it is simply piggy backing some functionality on the side,
 rather than creating a properly designed and general interface.

 I would feel happier about the patches if you removed all reference to uuids
 and then found some other way to ask a filesystem what its uuid was.

 This is not an issue that would make be want to stop the patches going
 upstream, but it does hold me back from offering a reviewed-by or
 acked-by (for whatever they might be worth).

NeilBrown

