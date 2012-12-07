Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423379Ab2LGA6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:58:52 -0500
Received: from smtp108.biz.mail.ne1.yahoo.com ([98.138.207.15]:40722 "HELO
	smtp108.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423274Ab2LGA5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:57:43 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vOF3KYoVM1kRsh2dQnFEgyDlxxZs7ptpwIbRD6q37_9p1aK
 asYhaU_TcBU5zqhJHpUjG7R_sTG6M9DnCKWgI3BqzqYg8Ye5Yfk2ehTdJXLj
 3DyP4B92cKXUY2IbXbNcBlpTIouYn_YxzOKj73jOoJwL6y2eC_Z3Dcq045pM
 pMApqIpVbaMGnapp.7Z39tUnPwliF1eYVQ7Sq.tvByCbW.5vaE4zPX7k2cym
 monP2UYGRWRH9f.JcFqKN.GWzXw1joVb9Al9vT0G9P6f26bajlx02kgIadTP
 XXoLifp0kpLXKU587jqnmby3JsKnOaFOc.IzfVlekRzj7HiZ3P9RJgMzbciT
 4.lSBVxZ_UAjRk19ZJe4BobPU3opAMIxARJKN4oE1gTmSG7ENap66PUS8fhZ
 5HvITFIKx2A9EcqcUJUsh9gv01DNEfPG2L6M8.sMeDqoL0Lk_J2XWx0x0.qy
 bQipkE6v5GAILFFzPztu.gRcv4_T1w1geLTDNY8s_SgQyKxGuxZ_CMsGu7bP
 MkQUCDG2rJlK8nZlhVfRwF45mFIaq3y8Ja2lCM2JUCKgUkbFmAJYO78V5HwQ
 CnOm2i.w161ac000N5InsJ3VENreyNmHmqqe0Ut1aspEA.JKBtW_yR6UD3vo
 6.Qo6vJhhKmuy1fuw
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50C13F0E.5010401@schaufler-ca.com>
Date: Thu, 06 Dec 2012 16:57:50 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
References: <CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com> <CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com> <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com> <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com> <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com> <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com> <20121204135445.GA7420@mail.hallyn.com> <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com> <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com> <20121205222040.GB14884@sergelap>
In-Reply-To: <20121205222040.GB14884@sergelap>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/2012 2:20 PM, Serge Hallyn wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> On Wed, Dec 5, 2012 at 1:05 PM, Serge Hallyn <serge.hallyn@canonical.com> wrote:
>>> Quoting Andy Lutomirski (luto@amacapital.net):
>>>> On Tue, Dec 4, 2012 at 5:54 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>>>>> Quoting Andy Lutomirski (luto@amacapital.net):
>>>>>>>> d) If I really wanted, I could emulate execve without actually doing
>>>>>>>> execve, and capabilities would be inherited.
>>>>>>> If you could modify the executable properties of the binary that has
>>>>>>> the privilege to wield a privilege then you are either exploiting an
>>>>>>> app bug, or doing something the privileged binary has been trusted to
>>>>>>> do.
>>>>>> That's not what I mean.  I would:
>>>>>>
>>>>>> fork()
>>>>>> munmap everything
>>>>>> mmap ld.so
>>>>>> set up a fake initial stack and the right fd or mapping or whatever
>>>>>> just to ld-linux.so
>>>>>>
>>>>>> That's almost execve, and privilege inheritance works.
>>>>> But of course that is why you only want to fill fI on programs you trust
>>>>> not to do that.  What you are arguing is that you want to give fI on
>>>>> programs you don't trust anyway, and so heck why not just give it on
>>>>> everything.
>>>>>
>>>> Huh?  I'd set fP on a program I expect to do *exactly* that (or use
>>>> actual in-kernel capability inheritance, which I would find vastly
>>>> more pleasant).  If I give a program a capability (via fP or fI & pI),
>>>> then I had better trust it not to abuse that capability.  Having it
>>>> pass that capability on to a child helper process would be just fine
>>>> with me *because it already has that capability*.
>>>>
>>>> The problem with the current inheritance mechanism is that it's very
>>>> difficult to understand what it means for an fI bit or a pI bit to be
>>>> set.  Saying "set a pI bit using pam if you want to grant permission
>>>> to that user to run a particular program with fI set" is crap -- it
>>>> only works if there is exactly one binary on the system with that bit
>>>> set.  In any case, a different administrator or package might use it
>>>> for something different.
>>>>
>>>> Suppose I use the (apparently) current suggested approach: I install a
>>>> fI=cap_net_raw copy of tcpdump somewhere.  Then I write a helper that
>>>> has fP=cap_new_raw and invokes that copy of tcpdump after appropriate
>>>> validation of parameters.  All is well.
>>> Since you're writing a special helper, you can surely have it validate
>>> the userid and make it so the calling user doesn't have to have
>>> cap_net_raw in pI?
>> I can and did.
> Oh, oops, I mis-understood what you meant was the problem.
>
> Yup, that is a real limitation.
>
> Yes, with the posix file caps you will be disappointed unless you see
> pI=X as "this user may run any program which is Inh-trusted with X" and
> fI=X as "this program may be run with X by any user Inh-trusted with X".
>
> It almost makes me want to say that there should be an execve-analogue
> to prctl(PR_SET_KEEPCAPS), which says caps will remain unchanged for one
> execve.  Or perhaps an intermediate securebits state between
> !SECBIT_NOROOT and SECBIT_NOROOT, which automatically transitions after
> the first execve to SECBIT_NOROOT.
>
>> The mere presence of a cap_net_raw+i tcpdump binary is more or less
>> equivalent to saying that users with cap_net_raw in pI can capture
>> packets.  I've just prevented pI=cap_net_raw from meaning anything
>> less than "can capture packets".  So I think we should bite the bullet
>> and just let programs opt in (via some appropriately careful
>> mechanism) to real capability inheritance.
> By real you mean more precise.  I think it'd be very interesting to get
> together with Markku and learn more from the N9 experiment!
>
> Markku, are there any post-mortem analysis papers we can read for
> starters?  Andy would not be trying to restrict root in general, so
> the ramification you cited may not necessarily be relevant.
>
> -serge

http://wt.tuxomania.net/publications/posix.1e/download.html

Everyone should read the capabilities rationale. It answers most
of the questions on this thread, and a bunch more. The capabilities
mechanism has to support what are currently setuid-root programs
without change and allow for new programs that use the mechanism
wisely and fully.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

