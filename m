Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0E1WAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:00:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54373 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0E1WAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=DRyKzCLbGpZ84gzOc2C6n9n9BcWVKJsYh8oIyd7N7JLL06dZ65IpZlKLv9oyHUvF32
         x6TLyggBxRcTcau9yO0p9c4qROE4hP5pwFe/5ltGYlJjOvNob6T9OX5+TBCc2wAQpYzh
         ABeEjZwXrR1B77cCm57MoKBnTSr/4nfZOoFew=
MIME-Version: 1.0
In-Reply-To: <AANLkTimg3iNFVcV7AWSc0MPoW7UwunwSdH4NNIxl_w-P@mail.gmail.com>
References: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
	<1275022651.2446.35.camel@edumazet-laptop>
	<AANLkTinROjXlrxl_vTAuTyAfj0bqPZiJJpBDa8lkc8IT@mail.gmail.com>
	<AANLkTin8zU1enOG-SiAaHhdqtNtqW_L1qNGEA9oKFJxz@mail.gmail.com>
	<AANLkTin5RRIrSwenr1wCuJlEvydVD9_d3U2ZLitSXigs@mail.gmail.com>
	<1275077173.2472.3.camel@edumazet-laptop>
	<AANLkTimg3iNFVcV7AWSc0MPoW7UwunwSdH4NNIxl_w-P@mail.gmail.com>
Date: Fri, 28 May 2010 16:00:06 -0600
Message-ID: <AANLkTikR_gCHbb0P7_QiG86egoV2bVOwhS5Sj-T4Yz-a@mail.gmail.com>
Subject: Fwd: Question about SIOCGIFCONF
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Jeffrey Merkey <jeffmerkey@gmail.com>
Date: Fri, May 28, 2010 at 3:57 PM
Subject: Re: Question about SIOCGIFCONF
To: Eric Dumazet <eric.dumazet@gmail.com>


Not a bad suggestion, however, redhat and all the major distros still
use ifconfig.   Do you think this should be fixed or is it a
non-issue?

Jeff

On Fri, May 28, 2010 at 2:06 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 28 mai 2010 à 13:05 -0600, Jeffrey Merkey a écrit :
>> The code in question is net-tools/lib/interface.c function
>> if_readproc() and associated routines.  Looks like a hole.
>>
>> Jeff
>>
>> On Fri, May 28, 2010 at 1:02 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>> > Review of the net-tools source code for IFCONFIG indicates that when
>> > /proc is not loaded and/or /proc/net/dev is not available, IFCONFIG
>> > will attempt to use this ioctl to determine which interfaces are
>> > present in the system.  Since the ioctl will not report unbound
>> > interfaces which are active, IFCONFIG will not properly report or
>> > detect network adapters which are unbound.  This seems to be a hole,
>> > although most of the time I assume /proc will always be mounted.
>> > Someone should review this and make a decision as to whether or not
>> > this could be a problem.  At any rate, it does not work as advertised.
>> >
>
> Maybe you could forget about a 20 years old legacy program and use the
> real thing : ip
>
> ip link
> ip addr
> ...
>
> Alternatively, you could rewrite ifconfig to use modern API.
>
> (Not depending on /proc , at all)
>
>
>
>
