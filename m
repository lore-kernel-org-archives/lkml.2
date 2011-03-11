Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1CKX4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 18:56:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33693 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1CKX4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 18:56:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L7iTLOUETNoQB6UTpp/VSh4vpcJdFPVFZNPcTrGRSf374SxQUQomjeHJqxYB2oCe23
         McrGDGdnq1+CNMMN02IYdHt3DXgQJ0OsyhemADGosLiYFvqgDrE2hpDnx/MM8wYkYBeW
         09eoM7Y3BpqbtP0T/iI5iO5fKqpQKkrXVItDc=
Date: Fri, 11 Mar 2011 17:56:15 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org,
        mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de,
        l@jasper.es
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Message-ID: <20110311235607.GB15853@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
 <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:

> If there still is a good reason to implement this, please don't add it
> as a new system call, but add it to sync_file_range(), as that seems
> the best place for odd file synchronisation operations.

I have no strong preference about how this is added (and in fact I'm
quite ignorant about the usual conventions), but:

 - as a sysadmin, it really _would_ be nice to be able to say
   "sync /usr" to sync /usr;

 - the existing functionality of sync_file_range is about controlling
   writeback behavior for files, not mounts.

So unless there is a shortage of syscall numbers or something, I find
the request to omit this or tack it onto sync_file_range odd.  Could
you explain the benefit?

Thanks,
Jonathan
