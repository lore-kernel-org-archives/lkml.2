Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3ADWK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:10:28 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:56997 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3ADWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:10:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
Date: Fri, 4 Jan 2013 14:10:25 -0800
X-Google-Sender-Auth: WB_Z16BpSoy9xkUjLBm_odQgA_c
Message-ID: <CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 1:02 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> Pani'cing the system doesn't sound like a good option to me in this
> case. This change to disable swiotlb is made for kdump. However, with
> this change several system fail to boot, unless crashkernel_low=72M is
> specified.

this patchset is new feature to put second kdump kernel above 4G.

>
> I would the say the right approach to solve this would be to not
> change the current pci_swiotlb_detect_override() behavior and treat
> swiotlb =1 upon entry equivalent to swiotlb_force set.

that will make intel system have to take crashkernel_low=72M too.
otherwise intel system will get panic during swiotlb allocation.

Thanks

Yinghai
