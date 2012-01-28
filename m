Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2A1VGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 16:06:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38391 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2A1VGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 16:06:17 -0500
MIME-Version: 1.0
In-Reply-To: <1327749226.15441.4.camel@cr0>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	<20120127234140.GA19407@suse.de>
	<CABqD9hZ9StgL_v-Z+hpGnbC6Ggu1N3hWXfV_gqUu6caCbcMCtQ@mail.gmail.com>
	<1327749226.15441.4.camel@cr0>
Date: Sat, 28 Jan 2012 15:06:15 -0600
Message-ID: <CABqD9hb0O8DKr0FeKA3WsP7deQW5v9HKGJQq5Cw_D6wN20z6og@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] seccomp: kill the seccomp_t typedef
From: Will Drewry <wad@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Cc: keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, indan@nul.nu,
        mcgrathr@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 5:13 AM, Cong Wang <amwang@redhat.com> wrote:
> On Fri, 2012-01-27 at 17:47 -0600, Will Drewry wrote:
>> On Fri, Jan 27, 2012 at 5:41 PM, Greg KH <gregkh@suse.de> wrote:
>> > On Fri, Jan 27, 2012 at 05:24:39PM -0600, Will Drewry wrote:
>> >> Replaces the seccomp_t typedef with seccomp_struct to match modern
>> >> kernel style.
>> >>
>> >> Signed-off-by: Will Drewry <wad@chromium.org>
>> >> ---
>> >>  include/linux/sched.h   |    2 +-
>> >>  include/linux/seccomp.h |   10 ++++++----
>> >>  2 files changed, 7 insertions(+), 5 deletions(-)
>> >>
>> >> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> >> index 4032ec1..288b5cb 100644
>> >> --- a/include/linux/sched.h
>> >> +++ b/include/linux/sched.h
>> >> @@ -1418,7 +1418,7 @@ struct task_struct {
>> >>       uid_t loginuid;
>> >>       unsigned int sessionid;
>> >>  #endif
>> >> -     seccomp_t seccomp;
>> >> +     struct seccomp_struct seccomp;
>> >
>> > Isn't 'struct seccomp_struct' a bit redundant?
>> >
>> > How about a simple 'struct seccomp' instead?
>>
>> Works for me - I can't recall why that seemed to make sense (other
>> than the user of similar redundant names elsewhere).
>
> seccomp_struct for a type is okay, but you also have:

Thanks. Looking again, I see the main benefit of seccomp_struct over
seccomp being that it help avoids error.  Ignoring task_struct :),
signal_struct and sighand_structs are a good example.  Since the
member name is "signal" and "sighand", I think this bit of redundancy
helps disambiuguate, but perhaps I'm just being overly conservative.

I'll leave it as is unless Greg or someone else feels strongly :)

> +#define seccomp_struct_init_task(_seccomp) do { } while (0);
> +#define seccomp_struct_fork(_tsk, _orig) do { } while (0);
> +#define seccomp_struct_free_task(_seccomp) do { } while (0);
>
> in patch 2/3, "struct" in these function/macro names is redundant.

Fixed - thanks!
