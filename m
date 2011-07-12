Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1GLIRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:17:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56694 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1GLIRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfuBxwET2zVWBJCBsUsEu661h+rzfHhtgvRY7SuBG7nPQLZnw@mail.gmail.com>
References: <CAJfuBxyhh=3rO9MLkfDic16mij4A6NLXEQnhsvHEmBKokMoF7A@mail.gmail.com>
 <CAO+b5-rP8JAqe5pV7x_4RR5aumpHi4JG5diHehe5BiS_QwzSvw@mail.gmail.com>
 <CAJfuBxxvDhRgwfosZHZEAsgeLsAzDigHh-j3mC+8aJByR-=GkQ@mail.gmail.com>
 <CAO+b5-pZPsbnpjnFzCQFxWrAtoeG71pn1wVqjcOrR9yBQ3L1nA@mail.gmail.com> <CAJfuBxwET2zVWBJCBsUsEu661h+rzfHhtgvRY7SuBG7nPQLZnw@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Jul 2011 10:16:55 +0200
X-Google-Sender-Auth: 5IyYJFQMotVuN7P_lyMGXXH577Q
Message-ID: <CAO+b5-oEgoCNsKoZOLQTBnb9UiS=iAawjVbJkd06+qjEr23vYg@mail.gmail.com>
Subject: Re: [ patch 00/21 ] support multiple, pending ddebugs at kernel-boot
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 9:39 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Mon, Jul 11, 2011 at 11:53 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> The above example contradicts the following code added in patch 09/21:
>>
>>        /* actually go and implement the change */
>>        nfound = ddebug_change(&query, flags, mask);
>> +
>> +       pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
>> +       if (!nfound)
>> +               return ddebug_save_pending(&query, flags, mask);
>> +
>>        return 0;
>
> In patch 13, that becomes
>
> +       if (!nfound) {
> +               if (flags & _DPRINTK_FLAGS_APPEND)
> +                       return ddebug_save_pending(&query, flags, mask);
> +               else
> +                       pr_warn("no match on: %s\n",
> +                               show_ddebug_query(&query));
> +       }
>        return 0;
>  }
>
>
> its altered once more, when I add filter-flags,
> but that doesn’t really change my assertion.
>
>        nfound = ddebug_change(&query, flags, mask, filter);
>        if (!nfound) {
> -               if (flags & _DPRINTK_FLAGS_APPEND)
> +               if (flags & _DPRINTK_FLAGS_APPEND ||
> +                       filter & _DPRINTK_FLAGS_APPEND)
>                        rc = ddebug_save_pending(&query, flags, mask);
>

Sorry, but I'm not sure that addressing review comments by adding
follow-up patches that modify previous patches is the proper way to
present a patch series. IMHO this patch series would be a lot easier
to review if patches that modify previous patches in the same patch
series were avoided. If you are not yet familiar with patch squashing
via git rebase --interactive, I think it's a good idea to learn more
about it first.

Also, what are the implications for bisectability if review comments
about bugs are addressed by follow-up patches instead of modifying the
patches on which the comments apply ?

Thanks,

Bart.
