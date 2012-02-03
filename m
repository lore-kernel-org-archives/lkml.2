Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2BCRd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:33:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58225 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab2BCRd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:33:57 -0500
Message-ID: <4F2C1A46.4010105@zytor.com>
Date: Fri, 03 Feb 2012 09:32:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org> <20120203092823.GE1968@moon>
In-Reply-To: <20120203092823.GE1968@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 01:28 AM, Cyrill Gorcunov wrote:
> static __init int kcmp_cookie_init(void)
> {
> 	int i, j;
>
> 	for (i = 0; i<  KCMP_TYPES; i++) {
> 		for (j = 0; j<  2; j++)
> 			get_random_bytes(&cookies[i][j], sizeof(long));
> 		cookies[i][1] |= (~(~0UL>>   1) | 1);
> 	}
>
> 	return 0;
> }
>
> I thought in first place that sizeof(cookies[i][j]) would allow me
> to change type of cookies in one place (ie at declaration) but
> if cookies type will be changed -- the code will need careful review
> anway, so sizeof(long) will be enough I think.
>
> On the other hands, maybe more clean variant will be
>
> static __init int kcmp_cookie_init(void)
> {
> 	const int size = sizeof(cookies[0][0]);
> 	int i, j;
>
> 	for (i = 0; i<  KCMP_TYPES; i++) {
> 		for (j = 0; j<  2; j++)
> 			get_random_bytes(&cookies[i][j], size);
> 		cookies[i][1] |= (~(~0UL>>   1) | 1);
> 	}
>

How about:

	const int size = sizeof(cookies[0]);

	get_random_bytes(&cookies[i], size);

... and skip the completely unnecessary for loop?

	-hpa

