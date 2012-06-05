Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2FERi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843Ab2FERiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:38:25 -0400
Message-ID: <4FCE4408.1030506@redhat.com>
Date: Tue, 05 Jun 2012 14:38:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>, linux-edac@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 5 (amd64_edac)
References: <20120605133000.f2d21fb02881ef54a7bfe728@canb.auug.org.au> <4FCE333F.6060207@xenotime.net>
In-Reply-To: <4FCE333F.6060207@xenotime.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Em 05-06-2012 13:26, Randy Dunlap escreveu:
> On 06/04/2012 08:30 PM, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> There will be no linux-next release tomorrow.
>>
>> Changes since 20120604:
> 
> 
> 
> on x86_64:
> 
> drivers/edac/amd64_edac_inj.o: In function `amd64_remove_sysfs_dbg_files':
> amd64_edac_inj.c:(.text+0x420): multiple definition of `amd64_remove_sysfs_dbg_files'
> drivers/edac/amd64_edac.o:amd64_edac.c:(.text+0x3d60): first defined here
> make[3]: *** [drivers/edac/amd64_edac_mod.o] Error 1
> 
> 
> Full randconfig file is attached.
> 
> 

Thanks for pointing it. The enclosed patch should fix it.

amd64_edac: Avoid compilation breakage

when:
	CONFIG_EDAC_AMD64=m
	CONFIG_EDAC_AMD64_ERROR_INJECTION=y
	# CONFIG_EDAC_DEBUG is not set

The compilation breaks, as amd64_remove_sysfs_dbg_files() were not declared
as static.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 098f336..8d48047 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -421,7 +421,7 @@ static inline int amd64_create_sysfs_dbg_files(struct mem_ctl_info *mci)
 {
 	return 0;
 }
-void inline amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)
+static void inline amd64_remove_sysfs_dbg_files(struct mem_ctl_info *mci)
 {
 }
 #endif
