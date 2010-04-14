Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0DNHcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:32:14 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:54133 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0DNHcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jdq1dnpEdncc2DT4WGOwNtjPClNsqP44yeP8Njsg3l1SA7pHASTvkB8V8KBxK9+z/2
         XkOCjhor8nrNG+g1raWzZaM5tyCJOK3S4i/3xy9ZUbZ4MueCOvfH9WcbowA/WZJ2+QkG
         IdghUD31FBaQEWn3mqwiwxlQHPxrh2ngN+Hk4=
Date: Wed, 14 Apr 2010 15:35:54 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, jmorris@namei.org
Subject: Re: Security: Replace dac_mmap_min_addr to mmap_min_addr in
 cap_file_mmap()
Message-ID: <20100414073554.GB4503@cr0.nay.redhat.com>
References: <20100414024842.GB3718@localhost.localdomain>
 <j2z7e0fb38c1004132002sba54d278xc0337bed6e09dec5@mail.gmail.com>
 <v2l628d1651004132250nf7df1f63y2494df724adda489@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v2l628d1651004132250nf7df1f63y2494df724adda489@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 01:50:40PM +0800, wzt wzt wrote:
>still not understand,  if CONFIG_LSM_MMAP_MIN_ADDR is not set,
>mmap_min_addr is equal dac_mmap_min_addr, right?
>if not, mmap_min_addr is set as CONFIG_LSM_MMAP_MIN_ADDR.  what's the
>effect of mmap_min_addr?  except round_hint_to_min() will use
>mmap_min_addr, any other functions will call it?

round_hint_to_min() will be called by mmap().

As the names tell you, mmap_min_addr will be checked by mmap(),
dac_mmap_min_addr will be checked for CAP_SYS_RAWIO.

Please check commit 788084ab, as Eric suggested.

>Anyway, the comments need change mmap_min_addr as dac_mmap_min_addr,
>right? If i'm wrong, please point it, thanks.
>/*
> * If the process is attempting to map memory below mmap_min_addr they need   |{
> * CAP_SYS_RAWIO.
> */
>

Yes, I think the comment needs to be fixed.

Thanks.
