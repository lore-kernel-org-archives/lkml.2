Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab1DZUhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:37:02 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:48047 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757620Ab1DZUg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:36:59 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB72CB9.3050203@verizon.net>
Date: Tue, 26 Apr 2011 16:36:09 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <mmarek@suse.cz>, <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] kbuild: mark unicore32 header export as broken
References: <4DB4AEF7.3090607@verizon.net> <BANLkTi=K3OEumicFMCT_Dh=xhpzfpa3JBw@mail.gmail.com>
In-Reply-To: <BANLkTi=K3OEumicFMCT_Dh=xhpzfpa3JBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/2011 2:48 AM, Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Apr 24, 2011 at 7:15 PM, Peter Foley <pefoley2@verizon.net> wrote:
>> This patch marks userspace header export for unicore32 as broken so that
>> it is skipped when running make headers_install_all.
>>
> Why ?
> 
> I would expect you to send this to arch/unicore32 maintainer too, he
> is not in the CC: list.
> 
>  - Arnaud
> 

Sorry, I've CC'd him on this email.

The error I currently get is:

  INSTALL include (0 file)
make[3]: *** No rule to make target `/usr/src/git/arch/unicore32/include/asm/auxvec.h', needed by `/root/linux/t/usr/include/asm/.install'.  Stop.
make[2]: *** [headers_install] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Patch below.

This patch marks userspace header export for unicore32 as broken so that
it is skipped when running make headers_install_all.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 scripts/headers.sh |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/headers.sh b/scripts/headers.sh
index 978b42b..3ae218e 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -21,6 +21,8 @@ for arch in ${archs}; do
 		;;
 	cris)      # headers export are known broken
 		;;
+	unicore32) # broken
+		;;
 	*)
 		if [ -d ${srctree}/arch/${arch} ]; then
 			do_command $1 ${arch}
-- 1.7.5.rc1 
