Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1HRWZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:25:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59475 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab1HRWZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:25:31 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Pavel Ivanov <paivanof@gmail.com>
Subject: Re: running of out memory => kernel crash
Date: Fri, 19 Aug 2011 00:25:27 +0200
User-Agent: KMail/1.8.2
Cc: Mahmood Naderan <nt_mahmood@yahoo.com>,
        David Rientjes <rientjes@google.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        "\"linux-mm@kvack.org\"" <linux-mm@kvack.org>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <CAK1hOcM5u-zB7fUnR5QVJGBrEnLMhK9Q+EmWBknThga70UQaLw@mail.gmail.com> <CAG1a4rus+VVhhB3ayuDF2pCQDusLekGOAxf33+u_uzxC1yz1MA@mail.gmail.com>
In-Reply-To: <CAG1a4rus+VVhhB3ayuDF2pCQDusLekGOAxf33+u_uzxC1yz1MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201108190025.27444.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 August 2011 16:26, Pavel Ivanov wrote:
> On Thu, Aug 18, 2011 at 8:44 AM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
> >> I have a little concern about this explanation of yours. Suppose we
> >> have some amount of more or less actively executing processes in the
> >> system. Suppose they started to use lots of resident memory. Amount of
> >> memory they use is less than total available physical memory but when
> >> we add total size of code for those processes it would be several
> >> pages more than total size of physical memory. As I understood from
> >> your explanation in such situation one process will execute its time
> >> slice, kernel will switch to other one, find that its code was pushed
> >> out of RAM, read it from disk, execute its time slice, switch to next
> >> process, read its code from disk, execute and so on. So system will be
> >> virtually unusable because of constantly reading from disk just to
> >> execute next small piece of code. But oom will never be firing in such
> >> situation. Is my understanding correct?
> >
> > Yes.
> >
> >> Shouldn't it be considered as an unwanted behavior?
> >
> > Yes. But all alternatives (such as killing some process) seem to be worse.
> 
> Could you elaborate on this? We have a completely unusable server
> which can be revived only by hard power cycling (administrators won't
> be able to log in because sshd and shell will fall victims of the same
> unending disk reading).

You can ssh into it. It will just take VERY, VERY LONG.

> And as an alternative we can kill some process 
> and at least allow administrator to log in and check if something else
> can be done to make server feel better. Why is it worse?
> 
> I understand that it could be very hard to detect such situation

Exactly. Server has no means to know when the situation is
bad enough to start killing. IIRC now the rule is simple:
OOM killing starts only when allocations fail.

Perhaps it is possible to add "start OOM killing if less than N free
pages are available", but this will be complex, and won't be good enough
for some configs with many zones (thus, will require even more complications).

-- 
vda
