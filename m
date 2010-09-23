Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0IWBWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:22:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39210 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0IWBWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jmiV8YmNRMEqh+Npw5LvhaDotMG2Ey0SeLbdlRHd3m29hGViV+9oQeSwqoSky8ctIS
         BYa4CTuuiBRYokmpG1VXrFez6He259BsHOR19d6ZIjsmsL8bUsA/Y3hqFruw1DSjtvYh
         b1pBxceeVMaZbz7DzB9YYRH0hBxYIkSe0qHfE=
MIME-Version: 1.0
In-Reply-To: <1285169160.10774.317.camel@albahaca.inf.um.es>
References: <1285152908.10774.306.camel@albahaca.inf.um.es>
	<201009221410.17056.diegocg@gmail.com>
	<1285169160.10774.317.camel@albahaca.inf.um.es>
Date: Wed, 22 Sep 2010 21:22:16 -0400
Message-ID: <AANLkTin79hYV-faSdpC=MUWMR9ujtyORVe=0HNDPT1k-@mail.gmail.com>
Subject: Re: CFQ I/O scheduler better than AS?
From: Yuehai Xu <yuehaixu@gmail.com>
To: Juan PC <piernas@ditec.um.es>
Cc: linux-kernel@vger.kernel.org, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juan,

I don't think the removal of AS is because of its performance compared
with CFQ. Actually, the essential idea of these Non work conserving
schedulers, CFQ and AS, is the same, that is to avoid deceptive
idleness. You can google AS/CFQ, and I am sure you can get enough info
about it.

In my opinion, AS is just a component of CFQ, every single process has
a corresponding cfqq in CFQ, in which anticipation might be done just
as AS. The reason why AS is removed might be because of this. Of
course, I am not expert, this is just my own opinion.

And, except the non work conserving model, CFQ considers fairness
which AS doesn't. You might have found some benchmarks that AS gains
better performance than CFQ. Actually, both of the two schedulers have
some trick parameters to set, for example, its anticipation window,
(antic_expire and slice_idle), you can find it in
/sys/block/sda/queue, different throughput might be gained when you
set it to different value. From this perspective, it might be unfair
to compare these two schedulers because you can optimize the
throughput by configuring the parameters.

Another reason might be because AS is not maintained by developers
since it is just a component of CFQ.

Yuehai

On Wed, Sep 22, 2010 at 11:26 AM, Juan PC <piernas@ditec.um.es> wrote:
> Hi Diego,
>
> El mié, 22-09-2010 a las 14:10 +0200, Diego Calleja escribió:
>> On Miércoles, 22 de Septiembre de 2010 12:55:08 Juan PC escribió:
>> > Hi:
>> >
>> > I am sure that, for most people, the clear answer is "yes" (after all,
>> > CFQ is the default I/O scheduler in Linux), but we are having serious
>> > difficulties to find a benchmark which shows that CFQ is undoubtedly
>> > better than AS.
>>
>> The AS io scheduler was removed in 2.6.33 (7 months ago, in commit
>> 492af6350a5ccf087e4964104a276ed358811458), so you must be running
>> benchmarks in old kernels. The CFQ scheduler used in recent kernels
>> should have good performance (if it doesn't, you probably should
>> write a bug report ccing jens.axboe@oracle.com)
>>
> Well, 2.6.30/31 are not so old ;-)
>
> However, this fact reinforces my question. I guess that AS was removed
> due to a good reason, probably, some benchmark results. If so, those are
> the benchmarks I am looking for. Do you know their names?
>
> Thanks in advance!
>
>        Juan
>
> PD: BTW, congratulations for your D'Oh blog ;-)
>
>> Saludos ;)
> --
> D. Juan Piernas Cánovas
> Departamento de Ingeniería y Tecnología de Computadores
> Facultad de Informática. Universidad de Murcia
> Campus de Espinardo - 30080 Murcia (SPAIN)
> Tel.: +34868887657    Fax: +34868884151
> email: piernas@ditec.um.es
> PGP public key:
> http://pgp.rediris.es:11371/pks/lookup?search=piernas%
> 40ditec.um.es&op=index
>
> *** Por favor, envíeme sus documentos en formato texto, HTML, PDF o
> PostScript :-) ***
> You have new mail in /var/spool/mail/piernas
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
