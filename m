Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2DQQce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:32:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27903 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab2DQQcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:32:33 -0400
Message-ID: <4F8D9B06.109@parallels.com>
Date: Tue, 17 Apr 2012 20:32:06 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH c/r -mm] c/r: prctl: Simplify PR_SET_MM on mm::code/data
 assignment
References: <20120416225520.GD9756@moon> <CAGXu5jKHZSXXxWQdkQ2d0-soaUkQys85XjQ1M2Fx_hg5vTrs2Q@mail.gmail.com>
In-Reply-To: <CAGXu5jKHZSXXxWQdkQ2d0-soaUkQys85XjQ1M2Fx_hg5vTrs2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 08:26 PM, Kees Cook wrote:
> On Mon, Apr 16, 2012 at 3:55 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> The mm::start_code, end_code, start_data, end_data members
>> are set during startup of executable file and are not changed
>> after.
>>
>> But the program itself might map new executable or/and data areas in
>> time so the original values written into mm fields mentioned above
>> might not have correspond VMA area at all, thus if one try to
>> use this prctl codes without underlied VMA, the error will be
>> returned.
> 
> Hrm, what is the utility of these fields then? If they're not "real",
> should the kernel even bother tracking it at all? (Or, should it be
> fixed to actually do something useful?)

As far as I see these values are used by aout binfmt core-dumping code
and in flat relocations load. Elf doesn't read either of them, just loads.

> -Kees
> 

