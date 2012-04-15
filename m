Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2DOLrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:47:12 -0400
Received: from nm19.bullet.mail.bf1.yahoo.com ([98.139.212.178]:39672 "HELO
	nm19.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752626Ab2DOLrK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:47:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 497792.71479.bm@omp1063.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ImPrtLjRAIFmiwgZeoKsNdRUTQxyWhImgOxA0HmWZkcTHwySG/1qVwXbwn4UcDSKP8Isx9L4usON1Q/mH1e76n5LOSKnTi7lHsJxzU06vG1eA1iNRu6fFxni76Jvgc+fL1kqbUkwtd1njuYZ1Hw0Wh1zGQn6O+CRigOCsNpiznk=;
X-YMail-OSG: HFpDvL8VM1mMeRhIIYTfZF12L4cZevD4UAK.YgatRmdfhpm
 G_GoSIthKV8em7aZd006lUWIuikprYLgtBCQduLk06uWpJAqOQICjwbV6sol
 WEY3YLUT9DVRkH8sJjK4Af2bOs4qqswUNajYGUImB03WvnzbHpYJJzd_NbQ1
 xs2VjXTpEtYwMiPuFfIfXybVQ90Sjw6cg6pZOf6rdmoFQmpwSFXDA1qM2hbT
 dNERaTZ._ly0S.KijtIV3SPUcAwZGIY2UoGFbNjyBrv1Dkeribt8c7nFwHJ6
 i.EuIJGuYI84HZR5QGcOJjDwRAzqipua.ffPNygiZ4mTQNezyx4BysmOKibP
 e3v92RTm7rpi1_gQQiUHjoECqj8EcbPsJ3ZB4i5iFw0YyW5dVKcknz5X7ewb
 KcOra8je1NejibQ3OHSAH1fxd7IqMyvqlfkvp4zrh62qymEKd.ZnobP2uVOk
 qgi1Pz399Mxsw8JQV5fxwMSa6QFcPNZPppBkSKfk2ZcU1qDP4qGXI
X-Mailer: YahooMailWebService/0.8.117.340979
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com> <CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com>
Message-ID: <1334490429.67558.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Date: Sun, 15 Apr 2012 04:47:09 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
In-Reply-To: <CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 
> This is fundamentally flawed.
> You're assuming that only one program will use this interface.
> Linux is a multi/user-tasking system

Dear Richard, Thank you for your comments.
I am sorry but this is meant only for *root* user.
That is only root user can do this: "echo 512 > /dev/shrinkmem"
If other user try to write in it: it says permission denied as follows:
pintu@pintu-ubuntu:~$ echo 512 > /dev/shrinkmem
-bash: /dev/shrinkmem: Permission denied

Moreover, this is mainly meant for mobile phones where there is only *one* user.

> 
> If we expose it to user space *every* program/user will try too free
> memory such that it
> can use more.
> Can you see the problem?
> 
As indicated above, every program/user cannot use it, as it requires root privileges.
Ok, you mean to say, every driver can call "shrink_all_memory" simultaneously??
Well, we can implement locking for that.
Anyways, I wrote a simple script to do this (echo 512 > /dev/shrinkmem) in a loop for 20 times from 2 different terminal (as root) and it works.
I cannot see any problem.
Can you elaborate more please?


Thanks,
Pintu
