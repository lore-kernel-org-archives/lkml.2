Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2FRHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 03:25:57 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36308 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FRHZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 03:25:55 -0400
X-AuditID: b753bd60-996f1ba000000f6c-55-4fded8008410
X-AuditID: b753bd60-996f1ba000000f6c-55-4fded8008410
Message-ID: <4FDED7D8.7070106@hitachi.com>
Date: Mon, 18 Jun 2012 16:25:12 +0900
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Cc: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>,
        vgoyal@redhat.com, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <4FB92D5A.3060507@redhat.com> <4FB9A92D.7050108@cn.fujitsu.com> <4FB9FE08.4050905@redhat.com> <4FBA05F6.8070804@cn.fujitsu.com> <4FBA0C8A.2050003@redhat.com> <4FBB0ACA.2040907@cn.fujitsu.com> <4FC30C40.80500@cn.fujitsu.com> <4FC37D94.3080404@redhat.com> <4FC47579.2040504@cn.fujitsu.com> <4FD58399.4050700@cn.fujitsu.com> <4FD9E3FF.4050906@redhat.com>
In-Reply-To: <4FD9E3FF.4050906@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Avi, Yanfei

I'm YOSHIDA Masanori from Hitachi, a developer of livedump.

 >> And here is a new case from the LinuxCon Japan:
 >>
 >> Developers from Hitach are now developing a new livedump mechanism for the
 >> same reason as ours. They have come to the situation *many times* that guest
 >> machines crashed due to host's failures, in particular, under development.
 >
 > This has happened to me as well, possible even more times .  I don't
 > use crash dumps for debugging but different people may use different
 > techniques.

As Yanfei's introduction, I'm developing livedump for cases where
guests crash due to host's failures.

Especially in very important systems, it is strongly requested to
identify the root cause of any failure even if it is very rare.
For this purpose, crash dumps must be obtained.
Therefore, we think livedump technique must be applied to the
virtualization system on that kind of area.

 >>> After the buggy situation is reproduced, we panic the host *manually*.
 >>> Then we could use userland tools to get guest machine's crash dump from 
host machine's
 >>> with the feature provided by this patch set. Finally we could analyse them 
separately
 >>> to find which side causes the problem.
 >>>
 >>
 >> Could you please tell me your attitude towards this patch?
 >
 > I still dislike it conceptually.  But let me do a technical review of
 > the latest version.

Actually, current implementation of livedump is just a core part,
which dumps only the image of kernel space. And I'd like to expand
it to obtain guest image at the same time too.
Also for this situation, VMCSINFO seems necessary to be exported.

Thanks,
YOSHIDA Masanori

Yokohama Research Laboratory,
Hitachi, Ltd.
