Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0GRXcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 19:32:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab0GRXcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 19:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rS1+lZ29ef0dgmsWm5UschvdoV62gKIS2FKy1NpSB2e6Ga4qtAWqftlD6wIyeq39sB
         FY90zDWM1kw3MXDHLAK5tkCAX9VtQ7cCN1AT/YTEsG0wJ+Qbylps3PNb0snkUuYMQ/ws
         pAv2GqRTujYweyqxCukpuiGggGHsmTsDPeqWY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Testing of function/data-sections on linux-2.6.35-rc4
Date: Mon, 19 Jul 2010 01:31:56 +0200
User-Agent: KMail/1.8.2
Cc: Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Parisc List <linux-parisc@vger.kernel.org>
References: <201007181703.17022.vda.linux@googlemail.com> <AANLkTin-9VsTJxGclRUrJIizn9aDZ6pjxmByBCWB0Hqr@mail.gmail.com>
In-Reply-To: <AANLkTin-9VsTJxGclRUrJIizn9aDZ6pjxmByBCWB0Hqr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007190131.56633.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 July 2010 20:24, Geert Uytterhoeven wrote:
> On Sun, Jul 18, 2010 at 17:03, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> > I am sending this email from the machine which runs the kernel
> > built with -ffunction-sections -fdata-sections --gc-sections.
> 
> (sorry for the previous HTML-email)
> 
> For the record, what are the metrics of this kernel vs. the standard one?

Kernel:

   text    data     bss     dec     hex filename
8299299  857324  785348 9941971  97b3d3 linux-2.6.35-rc4.obj/vmlinux
7656461  841508  783700 9281669  8da085 linux-2.6.35-rc4-fs.obj/vmlinux
7566908  832388  717844 9117140  8b1dd4 linux-2.6.35-rc4-fsgs.obj/vmlinux

The largest module in my build:
   text    data     bss     dec     hex filename
 451009   54640    2224  507873   7bfe1 linux-2.6.35-rc4.obj/fs/xfs/xfs.ko
 450519   54292    2202  507013   7bc85 linux-2.6.35-rc4-fs.obj/fs/xfs/xfs.ko
 450521   54292    2202  507015   7bc87 linux-2.6.35-rc4-fsgs.obj/fs/xfs/xfs.ko


-- 
vda
