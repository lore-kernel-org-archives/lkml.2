Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1JTIpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:45:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49645 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1JTIpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:45:41 -0400
MIME-Version: 1.0
In-Reply-To: <20111020081451.GC14464@moon>
References: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
 <CAOJsxLGZLx-Wybi=BM41pN5X5Xw=qw4dEC_q=Qy903GpKj6Nzw@mail.gmail.com> <20111020081451.GC14464@moon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 20 Oct 2011 10:45:01 +0200
Message-ID: <CAPybu_3kqqtfv1XyhruS3AMiRbd=wdMUr4rJL1UmDG_+z2m9jA@mail.gmail.com>
Subject: Re: [PATCH] tools/perf: Increase symbol KSYM_NAME_LEN size
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@elte.hu, acme@ghostprotocols.net,
        anton@samba.org, daahern@cisco.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That is 4gb size :S..... I have tried making a dummy program

int tttttt......ttttt (int a, int b){
return a+b;
}

int main(int arg, char *[]argv){
    return tttt....tttt(1,2);
}

and it has worked at least until t^16384 both in gcc and in gdb, and I
guess it would have continue working until much more.

Right now, I think we can increase it until 512, to be on the safe
side, and keep it simple. What do you think?

  best regards

On Thu, Oct 20, 2011 at 10:14, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Oct 20, 2011 at 10:54:40AM +0300, Pekka Enberg wrote:
> ...
>>
>> Is there some specified maximum length for symbols (e.g. in ELF spec)?
>> I'm OK with the patch but I'd prefer we didn't bump up the number
>> blindly there's something "official" number we can use.
>>
>>                         Pekka
>
> Elf restricts offsets in string table by 4 bytes, so probably the option
> is to have complete .strtab being read somewhere and use indices when needed.
> (note I didn't check where perf tool need those names).
>
>        Cyrill
>



-- 
Ricardo Ribalda
