Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab1CDOb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:31:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40184 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab1CDOb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:31:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pBASrH0khO26sfgOZIBeMpELaaJEtPGcrw5yORYrvRWQXBfwUzTaxUpGR0E5Tu/YKP
         Z0fcQoYxCKgQHplOTjQquhu2OUdI1VvWkN2yH1WTONXkVNkaUJKwM5i6C2bMoVMHpk9h
         q4nCj4pz4QkGr/lDYuQAGkzmwE/pvOjrSQvwM=
MIME-Version: 1.0
In-Reply-To: <20110304140745.GP20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com> <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
 <20110304134126.GL20499@htj.dyndns.org> <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com>
 <20110304140745.GP20499@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 4 Mar 2011 15:31:15 +0100
Message-ID: <AANLkTina7D3QffUK7vYvc3aVTvbcJQqm8VgQP3xJKYdw@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 3:07 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Mar 04, 2011 at 02:59:32PM +0100, Denys Vlasenko wrote:
>> I would rather speed strace up than slow it down further, even if
>> slightly.
>
> The question to ask is at what cost?  If mostly unnoticeable slow down
> makes the API cleaner, I'll go that way.  Everything is a tradeoff.

# time sh -c 'ls -lR /usr/share >/dev/null'
real	0m2.633s
user	0m0.540s
sys	0m2.047s

strace without PTRACE_GETSIGINFO:

# time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
exit_group(0)                           = ?
real	0m47.023s
user	0m3.843s
sys	0m29.050s
# time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
exit_group(0)                           = ?
real	0m48.799s
user	0m3.808s
sys	0m29.736s
# time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
exit_group(0)                           = ?
real	0m47.695s
user	0m3.965s
sys	0m29.047s

strace with PTRACE_GETSIGINFO:

# time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
exit_group(0)                           = ?
real	0m51.958s
user	0m3.899s
sys	0m31.584s
# time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
exit_group(0)                           = ?
real	0m53.773s
user	0m3.920s
sys	0m29.713s
# time sh -c './strace -e trace=exit_group ls -lR /usr/share >/dev/null'
exit_group(0)                           = ?
real	0m51.625s
user	0m3.961s
sys	0m30.970s

-- 
vda
