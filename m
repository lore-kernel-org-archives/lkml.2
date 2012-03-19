Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948Ab2CSWlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 18:41:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52731 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab2CSWlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 18:41:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120319223941.GJ19594@moon>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.925446961@openvz.org>
	<20120319151507.93bab32a.akpm@linux-foundation.org>
	<20120319223941.GJ19594@moon>
Date: Mon, 19 Mar 2012 23:41:36 +0100
Message-ID: <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new mm_struct::exe_file
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:39 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Mon, Mar 19, 2012 at 03:15:07PM -0700, Andrew Morton wrote:
> ...
>> >
>> > Also this action is one-shot only. For security reason
>> > we don't allow to change the symlink several times.
>>
>> What is this mysterious "security reason"?
>>
>
> Oh, sorry I should have included Matt's comment here
>
>        | Before this patch that state was rather ephemeral and almost entirely
>        | under the control of the kernel. The only way userspace could change it
>        | was by unmapping the region(s) mapped during exec*(). At that point it
>        | could not "lie" and insert some other symlink there and the admin would
>        | be better able to determine what had happened.
>        |
>        | With this patch -- especially the multi-shot form -- the symlink will
>        | be entirely under the control of (potentially untrusted) userspace code
>        | and the admin is totally at the mercy of the userspace code. In
>        | single-shot form programs could use the prctl() to ensure the symlink
>        | could not be changed later -- the restart tool would be the only program
>        | that would need to ensure that prctl() had not been used since the last
>        | exec*().
> ...
>>
>> It should be explained here also.  The comment is pretty useless - if
>> we don't tell people what this "security reason" is, how can future
>> developers be sure that they aren't violating it?
>>
>
> Actually I liked multi-shot version more but Matt arguments convinced
> me that one-short fashion is more "secure" in terms of overall kernel
> state and potential transitions/changes of this /proc/pid/exe symlink.
>
> At least with one-shot version the admin may be sure that the symlink
> is never changed more than once, ever.
>

And changing it once does not harm security?
I'm sure that rootkit writers will like this feature...

-- 
Thanks,
//richard
