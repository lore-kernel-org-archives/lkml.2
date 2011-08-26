Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1HZVtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:49:23 -0400
Received: from nm22.bullet.mail.sp2.yahoo.com ([98.139.91.92]:27987 "HELO
	nm22.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755531Ab1HZVtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:49:22 -0400
X-Yahoo-Newman-Id: 662652.76352.bm@omp1018.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: gYBC.TYVM1m4sxyjrc9Fz2S_0N0eh6rhkG8GlsdTwZROxO2
 8oY_tdUyTBGjk8Vyha0m5t.yWbzqkkNdPd1Jw8TPiZ6DVRGB56QBG_cfq_yf
 ScicxtN5uo1wsqbZgbKSBdI5UcLuUOjWtgE18Ni1dffePXgKT1Y5vNNbVL6y
 GKLVa.pKUfhQE6X1qKgZ0JqVnf2AWm4NO6EXfOYIETb6xFUGp9T.Y8MgG3Ow
 uxDocoJAkQIand817mfDE8eLbSrBczTWmQkcmV8KY3QzuKmnVW3KOs2.5Lch
 V80vXHxFL_ZGTLJHdcVkFsmbQdicavMODPzf4rnNJ6jgouInnKHN8nGwndqH
 Y49r1wmWBo6aSvP69yzDGCtj.ZXfECsbATN27M3oMGEiQimtWgRKMXyOekHT
 oNmtAbg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E581469.9000401@schaufler-ca.com>
Date: Fri, 26 Aug 2011 14:47:21 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: Eric Paris <eparis@parisplace.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>  <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com>  <4E57C93C.3050602@schaufler-ca.com> <1314379723.25778.26.camel@moss-pluto>
In-Reply-To: <1314379723.25778.26.camel@moss-pluto>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2011 10:28 AM, Stephen Smalley wrote:
> On Fri, 2011-08-26 at 09:26 -0700, Casey Schaufler wrote:
>> Is that really how it works? The code reads as if the buffer
>> passed by write gets modified in place and the writer is expected
>> to use that. There is nothing in the code that looks like the
>> response is getting set aside for a subsequent read. If it works
>> the way you say it does it will be subject to races up the wazoo.
>> If it works the way I think the code says it does it is abusive
>> of the write interface.
> It is a transaction-based IO, modeled after nfsctl, recommended to us by
> viro when we first implemented selinuxfs.

OK, I get that. Looking at the code it sure as shooting ain't obvious
to someone unfamiliar with the transaction system what is going on,
and I'm taking it on faith that it's working correctly.

> Userspace writes the input
> arguments to the file, the kernel computes the result and stores it in a
> file-private buffer (hence unique for each open instance, not shared by
> multiple openers), and userspace then reads that result back.  Not racy,

Well, in the absence of forks or multithreading.

> not an abuse of write(),

I personally think it is, but given that the transaction model
is used elsewhere I don't have a viable argument against your
using it.

> and recommended by the vfs maintainer to us.  I
> think we're safe on that one.

Yes, I concur that you have followed the rules and advice given you.
That does not mean I agree that this is a good approach.

