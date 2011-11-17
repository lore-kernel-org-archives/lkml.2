Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1KQXmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:42:12 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:60687 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1KQXmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:42:10 -0500
Message-ID: <4EC59BCE.6050902@atlas.cz>
Date: Fri, 18 Nov 2011 00:42:06 +0100
From: Jiri Polach <clarinet@atlas.cz>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Clarinet <clarinet@atlas.cz>, 647095@bugs.debian.org,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz> <1321561946.25715.16.camel@work-vm>
In-Reply-To: <1321561946.25715.16.camel@work-vm>
Content-Type: multipart/mixed;
 boundary="------------060307030906080303070107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060307030906080303070107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/2011 9:32 PM, John Stultz wrote:
> On Wed, 2011-11-16 at 23:49 +0100, Clarinet wrote:
>> Hi all,
>>
>>>> Result of bisecting: v2.6.38-rc1 exhibits the problem. v2.6.37 and
>>>> many of the topic branches merged in the 2.6.38 merge window work ok.
>>>> Some other topic branches do not boot at all.
>>>>
>>>> Jiri: if you have gitk installed, then "git bisect visualize" can help
>>>> get a sense of what's in the middle of the regression range.
>>>> "gitk --bisect --first-parent v2.6.37..v2.6.38-rc1" might be a good way
>>>> to find mainline commits to test before finding a topic branch to delve
>>>> into.
>>>
>>> I have been able to narrow the interval manually a little bit from the
>>> "top" (the bad side) and I will go on from the bottom now. However,
>>> there seems to be a large area where kernels are unbootable for me -
>>> they mostly stop when init is called and I do not know why.
>>
>> Finally! After another 50+ compilations a have it! It took some time as
>> first I had to find a reason why some revisions did not boot (almost 2/3
>> were unbootable and the first bad commit was among them). Having this
>> solved I have been able to bisect without "skipping". The result is
>> surprising (at least for me) - believe it or not, the first bad commit
>> is 6610e089 "RTC: Rework RTC code to use timerqueue for events" from
>> John Stultz (I am sending him a copy of this message).
>>
>> I would never expect this would be a problem, but my understanding of
>> this commit is very limited, so I am certainly missing the point.
>> However, I have tried to compile 2.6.38 (which was "bad") with "Real
>> Time Clock" configuration option turned off and it behaves "normally"
>> then (= is "good").
>
> Huh. That's *very* odd.  Is your system doing anything in-particular
> with the RTC?  I don't have a clue right off, so probably the next step

Yes, it is very odd. The system does not do anything special with RTC. 
It is a diskless computational workstation.

> is doing a bit of instrumentation to try to figure out where exactly we
> trigger the behavior. Could you checkout commit 6610e089 and apply the
> patch below to see if we can't narrow it down?

With the patch applied the system does not show the strange behavior (= 
is "good").

> Could you also send your .config to me?

Sure. It is attached. I have found that if I turn CONFIG_RTC_DRV_CMOS 
off, the system behaves normally (= is "good") too.

Thank you.

Jiri Polach

> thanks
> -john
>
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 5856167..d049344 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -497,13 +497,13 @@ static int cmos_procfs(struct device *dev, struct seq_file *seq)
>   static const struct rtc_class_ops cmos_rtc_ops = {
>   	.read_time		= cmos_read_time,
>   	.set_time		= cmos_set_time,
> -	.read_alarm		= cmos_read_alarm,
> -	.set_alarm		= cmos_set_alarm,
> -	.proc			= cmos_procfs,
> -	.irq_set_freq		= cmos_irq_set_freq,
> -	.irq_set_state		= cmos_irq_set_state,
> -	.alarm_irq_enable	= cmos_alarm_irq_enable,
> -	.update_irq_enable	= cmos_update_irq_enable,
> +//	.read_alarm		= cmos_read_alarm,
> +//	.set_alarm		= cmos_set_alarm,
> +//	.proc			= cmos_procfs,
> +//	.irq_set_freq		= cmos_irq_set_freq,
> +//	.irq_set_state		= cmos_irq_set_state,
> +//	.alarm_irq_enable	= cmos_alarm_irq_enable,
> +//	.update_irq_enable	= cmos_update_irq_enable,
>   };
>
>   /*----------------------------------------------------------------*/



--------------060307030906080303070107
Content-Type: application/gzip;
 name=".config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename=".config.gz"

H4sICMWaxU4AAy5jb25maWcAlDxdc9u2su/9FZz0ztxzZk4aS3YctzN+gEBQRE0SDEBKcl4w
isy0ntpSjiSnzb+/uwApARQo556Z04S7i6/FfmOVn3/6OSIv+83zcv+4Wj49fY/+aNbNdrlv
HqLn5V9NtNqsvzz+8Vv0sFn/7z5qHh73MCJ7XL/8E/3VbNfNU/St2e4eN+vfovEv179cXr/d
ri6BJNk+RsXmWzS6iS4ufrv88NvVKBpfjEY//fwTFUXCp/r6asKr2+9A2wIWN9f6chw97qL1
Zh/tmv1PDuL6CkiP38cPXqhK1rTiotAxoyJm8ogUdVXWlU6EzEl1+6Z5+nJ99fafm+u311dv
OhoiaQojE/t5+2a5Xf35Dmje2aPv8O+wvH5ovljIYeSUFUxyqmkulK7LmFTsuDTNBL1TopaU
6TmpaBqL6RF7GIpUbMaKSp1F6okUJKZEVUcyxMas1KouSyEdhKoIvaskgZVPcCmZMZ3BTgt6
X4nA4Dyvjx+fRMF0nJMjpGAsRojOSYkLuUc2ODU16IwV0yo9PRNXxJ/wgBAw4yl4Uge4BkAt
GZyCw2FKwYuKyQD/0jnj09Q5m7nqnNxbLpRUJzF1JVDOFcsPw1XJC+RxQCIt4YKmUxLHmmRT
IXmV5r2VUqI0LWvN4wxlgFeBKyYZn0jgIkhgRu5PCSqeMz1T9woos4H5kRWLAA6EmtRZZdYP
DSU0BVngcMWKf2I9GVGsqktdMmmWIJL1haBDsXwCXwmXqtI0rYu7AbqSTFmYzKwHJDlRd1ok
htoTBrtlPmGyIEbRS6EUn5ycStWqZEUcQHeCfDnuDSlFWaM6KF2A6egtW8e8MmQn6xilUVqU
cD/AuxjMEDCSF9Mhypih0CIP4B4F7R2eEZndwz2qHhwlO9PVIiA5KZExlx9DYt9i4ERax0LD
3wPqJj/qUooJO0UhC+Ek/rhasaNi5KVOWVZ6SmeNNOJ8mKt/+A12KS8FSl3/fq22appkZKpu
37z9gg7p7W75rXl4u314jHzArg94+KcHWPUBN73vX3vfo4s+YPTmaBzujCqiHhIZMAnmDEbO
kauok4wo54wHDwMaB1b8zbunx8/vnjcPL0/N7t3/1AXJD4Pe/dJzNPCHdXLCcBx86M/R1Pjp
J9zCy9ejV2ULuBbYaFERx1ygGdN3oD7MAYK8VpoVM9g6bioH+3Q5PiwpQYdg4bzkoEdv3jgz
kWwGNw9qCHe0enps1nuHSy4eFKgSAVYZ0ba70dNPvOwJfYuZAGYcRmWfXA/iY8QR4S9xvEhn
fnd3fQJc5Tw+dDg1d00IGO4ZL+kJAP+klXMZYLL4Qucfa1azMPRkyETFKGyUwUURSqthjJ5d
HpEVWFl03MoHWQfUm8ggFgEYF0gp6qLybR5azN7nqe8yZtXERH1gJRnrBFzSOlIvn3ffd/vm
+SjgSKIB5/ltWmsT74RcNeASUkAkeHt95Q+xYFAZQqvgRVsicFhgSdNPQZJuO4Pr87s2sPze
h5grcnUULq5OtEp5Ut2OPnjiXYMBIODRwP6k4G1MZOhygE6lqEsV3CJcQIIOqJSMgqeL9SwU
ZEs//kB7pEo4kiMmNfixwvlGOXa/wUdID1Dy2PsuWGW/D3ubZCh4M2OLZBzcPqUHN4uBvIlV
QnrX0w642wKmBafuLWiilZjFgRlqHo+uPU2FCfWJ+N7Bl7rPvVk7GISCWdhkdARsAYICcYBS
IcMoqjJzA95SQgTgREpeNMwyCJWEdM0FVeWd1CUENJjyOOPAq+ikdo+R1BVzgkYGPtnBKj4t
SJbEjtqDU5EuwCQmLkClOXNDYO6YYhtwwwT6kOwYJb+zOWTZbL9sts/L9aqJ2DfwKLuIrB8i
unlZ7yG9PGq/P8WBvQZszBF4nuAFtPEX0mEoM8tNGBa4g1lu5z9M57KX6481l3cOTGX1xE7u
qSP4TVJB0nYX1siMTEIiDHN5p5Ii4RApTQO0xtyY1KcfMwo7jHnyaYKSoMiZ8DNJOOV4aIhD
Mrh6MBJg3sF99ONREDdM/GC6fk7ZLtGHSlYFEaDSQbgJo8zhUiH6OQImlqSqZH+QZFNQPQj8
Tebbbl2TkofGl/xwXy4uncN1MXJneNrD5XwBHDmilVmxR2SsHxy3lgX4i4on3K1E9BVAFzk/
hHJUzN5+Xu6ah66m8nW7+fL49Lj+w+C7+BzI2tgjKFVmiS5Gx6NSkTIJiwVFjUx4kTgaKiud
o0lwb8SYDYWqcntxqA+IuM5cIgtA00whmxQkPkHVRRBsRwSQbfjoaXg7Rkl6CC59U9sdDIsa
OWS2XoIxaf1lz+tM1PQUiDnXFNL5+97wVqm7S+MiUqs/G4zfXQPFhfXQhRBOGNhBY0ZiP/Xp
MDT56B63S927AYGTdiQDI3EDZ0a1696+WX35rxO+mzSWmdIHaOF9v/xxjk5P0ldJf2i+/89k
mKT+MKECBQlFaA5pXfQjq1Nsb2/DdDaBPjcTUEDSD2kdO3cIsDvxj9yGoftholdYfKR7hcUe
4XkWG9JBFjvYsyx26cIs7lH8AIvnoPDsR3hsCX+c6hUuO4SvsNmnPM9nSzvIaBd9ltMeYZjV
fZIArzsLjt7FSj9YbzEvjHs8zJdAIvWJeZUVY2fL7WbV7HabbbT//rWJlhAWfmmW+5dt41jd
isPqomAqdeMSk7U5LphPU6yx2VD2tXp7zTM3tu2XtRZjCCTcvL4kEpylVzMranDCWGiDHMSr
M+MEeWlGBK8c8ZAosCLG+mkbzQ88jBwqjBB8C3kP+SrPajcpsP5F5JBeJxKrTG3B3Is0iSQz
DiHAtIb7C6wErJwIUXkBPnxUTHlPOPndTfBAealCsXaO6cvYm4BUIg9Ocbiksh7gBGD8OzLH
NGVdW+q2mfUHb0xeYhXfH5eNvAHX3r2TOPap56WeC8gJtBuudstnJiykorz3cZiDlBAAa1iG
3qk699HlNXC8J3GVoj6g3XvvZQxfo2Y+JIfsOq9zU51MSM6zeyyFOAQmHoZkN1dOxIrUIFz2
GKdgksenQIp1x9oNe0tI+Y2+9WAsN2V3CDudU8W5E7FPicQwxb5HHTMrkgHi3iKCggIbO8V2
ujDnosombvgFhG0xuw+1+YMjmguwAiHdMO8b6vb9aOzrnMqrvhrmzmlLsHh5iZFa4SVrHXwm
MshA4bDBY7ZUA7pgyrDaN1FGJkUAKJkUYJxNdWUixR0rjLJr/3nBSBJlJ4C+gHRgT0A6YJVK
NNJZAMWL3xmtbp89mYcEBtIPPWNY+/bcz03oXS7nVAp8Az5OcwD193lEeDs9gmGX1oQk5OTY
oCjeRkEAeHwE2ael9B6S0DiWujo8dneCziWcSE8n+CDkFshqt7B9d9MDtG8shEIO62NMnQud
EHhWZJo+KXwZZ8SCWtEONsbuxj8CsELfoZXW4Lz7L6nW54Eb6LKKQTwrSOC1jmXIhNZvQYLn
PU5kGZvCzbfOSs9IVrPbi38emuXDhfO/g3qdm+y4kZwUNQlh3CIl6imchpeQcHZ87GyXKQfY
RUADFXNrBc55F5WEv4RQM/gPllD6LDlSmMqUtrstdSWmDG/0zFyelbJ7ayuJgctGiTMvbIcI
w505gyihrGy6izbt6qgWU2neXh37NSzf3XOrxpVuR4c8WtSFq0om5KggtKgdFt8p5zK6dNWw
DPyYWe/2+v37y2tfll6Lgobg6RwkTJlScWt+vCjMuGc9gWwZS62yLpEFAzYXxUFid4WYAz+c
YCCvpPS/tCIFr/gnNghv5eOgWRcDZCgMpgCGbqgjHrnbsjULl1kQfChdTiFqN2FO7MoPS3jI
bzKK1Q/H4VNba8NCYGebO45+0qOLC3dOgIzfX4RrVp/05cUgCua5COwGgvqRo/nGsaYScwBH
itiCeTE3lUSlOq6DLhxFmaPHhENJYPY/o9a6HJ+CGLpU8wZzbrypnjrjux1bdWxD1H6ZeBYr
EWQBzU3xB71xqNZlLrOVE1/vQ0VV22NQJgVqXMEdtTfBKESpEMQZL2FCZkNgM7DN3802el6u
l380z816b3Iw9EHR5uv+cbN2y/O5F8jkNrIM18Btr0b46o+tHuHYJ9cSnx7z0F3gzhyBR1+J
bizxvKEDBhczZ8EXfUODSOAuJkzPHsY+qxn8ycyM2pMn4ceIw+q2GDxMQ+gwbkIq2FQ4OLQE
dVUNMNDgE3IGGYcbnw47Z0qJPkd8KQ+O0GQ6BWNFqpPBbajXg/pRjgHRWkGOqGMVQ0LbNif4
e3coho4wycB4YSOGvge9uL3on74vtt5hKFx+JnqhKshkL8+xexEQwvPCSI+/hpqcEY40+EJp
ZaJk/ETgEKinKTszpSFh4OZeI8EOrTN66zsI+0ABOXmybf770qxX36Pdatl/ujCZp2QfA2fq
GuT8ZNK0zE3FTGfg8JkcQOas8OypzbgRfbLFvHnebL9HX40t2y2/wQZ37g75B/BD4aGTl11n
6aJ/weVHzX71y78do0cde4PCYaN7H5bn9qNHKXIQDv8pE8C0mIwv4IzmsTFUxM+JZ3Pw+xAq
BeMTQ5Fkoizv9dzRKOAYPlp5bW+wA4bBlBeVIZD0ikYAAksnwzaqHdDGVSGfiQSq5zFa2LAC
+sGe6nHeAjxeDs1ktLiqJ0ctTqt+jRNpuJgNjObCT6Xb1lb/3RFzOP9Rl1Iy0OnQ2U+Usb4Q
sn+a1ct++fmpib484n/wuXy/i95F7Pnladnzw/i2l1fYIeBoTvsmHURBDImh0UGIsLcgZSS2
dVL/iZGIOnSf7cQ5V/TIU04ux22tx8sdDBwn6u/vZL9YlKgx6cXIKvfzrbaXqj+yYIdXuqLZ
/73Z/gXaHghWwAUwZ1hd8IWXMbMKwsj7wFF54Y7jpU0X2+7so0kpIVuZEch4Ym0KLKEgA4gS
PsF+3NSbsSzK/reOU1r2FkAw1mrKoEC1BJLIMB5PyEt+DjkdejeBQ5tDhb2JLEP+S90XcFni
jvulCWSnJkPvJFgsVAPns3vE+x/GLxIJrrkuhp7NDdFreDMJVhWwN6FQaH5+iPiHp50wFlIq
Q5VJ4VpsgMQc0upnD1TRsgMfm9MABn+dHuQw1EjS0dB64lqzzhJ0+Ns3q5fPj6s3/ux5/F7x
cKDAy9n1kGBlZDLAFkBiNR0zTnBZ4Ue2jgayLhNzQdKWl702GZcYosSe8rliHFMaSgkBo2hV
uuzEbx1PIAdXA7FRRyAmv9OBuN7QpDmhpu77ColKySikRwcC4L+rSTIOB4AVKElYUavwa0s2
HjApE8njaXjbRjBVuGV2lpFC31yMR+E3zpjRgoX5lWU03KXLy8XAkUgWlpvF+H14CVJOgggG
fw5saw7nOTXqRy+fDo7kjDHkxPurQS6akkaYUTTUOBYX2JGkBDZeHzVYlqrnBqN9s9v3QnNc
r7yrpiycDJpLldhTIwoOWVs4cCG5JDEfKGIMpJlcxmFZmQwkxImWCzkgx3OOvfMqLP1znpOw
rMjkjg90bOLBfw3rACU8OQnQ4ubb46qJ4u3jN9sQdOzSf1y14Ej0Y5Da9hraBygs1aVOr33M
ZlVe+oWLDgb3UQ9ZmIoUMclEsGuolHbFhMt8jqXD3kN3Mjc9XL23+Y6YF4EGtE5ZTGdrR+pl
5bb5MpZ8NqAuLQGbyYEMFkI9nd4Dj2ZcDQgh/FGYUmT4BboKOb8SAhX89dtzDwAh+ClMMclN
gcJ9Nm+p4dxJWPwdGshbYIrzZFM1kE61eLK4ufnw6/XwWfRofOO8CNs48jgNhpGG2eA2FT4+
nQhyud3sN6vNkxspF6VfVWt75U4AOol7/OFx2FngAFp+1EM2oEVTrtQ5GlwzJvTX63ANuSOp
cxb2cx0BFXNMI/Jg8twRZdjT99yHUnlfVqLFWVMgJ3H08LjDbO0h+tysli+7JjL1vkT9J8Jw
Ldpso6PA2vWemtW+eXCSuHaBYuIxtQOrRbjX4nDmkKfokJLkpycBoO16vh1dh3DmV4L27eVk
tQUPBVEUXEeO7oXGM+d51APjjx4SzDNvHF32CObmmWLI2Wsxw+eSKpw/dPtLw/4Us1XEczrc
HQ0i7GUr8WmJSFHFowfrAXYvX79utvvjPSISg3wvUCM8tq3MwfDOrWuY4d5PZg2kmlZ+bAow
jKx5MdBzjgStDIb3327c9ln9C+T3r/9E++XX5j8Rjd/Cffz7VDSVdyiaSgsN+6UOLVSwxegw
pzyVTCU1eK3YfWY6LOYkQgcYTY9Ay35M0HVWFz0uUvxlHfGa6A08E9Op98smA1UQy2gCWSzt
IfDHvQbbmQDD0Gq7XO+QpV6l0c6E1db+9fskCX2Ngpv/npMirYhqO+afT+AZn8AfAQQoVf/g
AE2Fqto+uN5ZDnOdKxsbSlm+dqZMzDOIUMIxmVWFsKIbnFCx+SkRJ7044GguvNJ5hY9dhQ2Y
ZLDiDhRgXiZCMc2kdAUQUb5XVAgqDYfshW/W++3mCRvEo78f93/C5Ou3Kkmi9XIP4WD0iD9u
+bJcNY6tMLOmtD8rgtzf9RyPjVg4Mh1dj8MxrqFQPBtfDZwPdtTtGDe36u969bLbb56jGH8N
6ez46OVjkNR44LeSZvWPaigss5tbDG1tklvDZzcHkPAODdmRieYauF/MMwvloVKuwRSzE2Kw
leAdBjL0lqfnkANCbpCz+TCyzvgwcsbPsHnGKwjqTr1T+SrjnIgNhS0L9QBYVO5ZfAuTlQgn
ShZdwVWcxZc31x/CsmsIaB5fX53Dq/fvx+H474C/PIe/x06e8HUZApaQgSwfsWlZXV6HK10H
/LnjIX4xHnjoPhBcDuN5dTMevYY/s4HfTctbKPA16JxIsMfZybVDsEHZQPJsCXjxO7kMF28s
gbr5cDUK12QMgchi1OMzBGXFhyyPIQDbNL4Yn2M/Wi9YZ5gAKxuQfp4hiIdSNlR1OhoHm1ha
bHrCV9NEJE1L8ZlpeXZ9c0amh8yPQVZCpXxyhmuV5EnGzjBtyAwZ5JwXE+F3dlgzxMXbzfrp
e98Undgfo/AX/WcwnyY/LxhWtM4wCCXnzJV+6rceedWcL8unp8/L1V/Ru+ip+WO5+h49HMo+
PeOGbTJh39Y2tJ/cP/Y90tCrk9ul2gXGXudqbP7BhZhV3uszgLGJiDhhNYAwAbnwiBAyOoVc
nAy7eu/8Stq+fOH74Smqa6PEqpY7iXlYuD+N8uPczWji4VdgQJms+zgFQFRBSvP7DxeYcxO0
+dPiL+2xLd/8vj08/ScmhT/R6UlcqP6YDSCUvyH7z/y4EFsC9Mpttep1PtlfHDLGotHlr1fR
v5LHbTOH///byTYNzf3mJVot11GzNk/Fm3WDlYbPG/D13ZhWVqPdHiR490s3svqzidbN3x0C
V982q83zc7N+aB5+cSU74ZJhwXWwvG02GUJ2IyHqVsGH1bHDdfjQGa3sj2nv8UdDNCWF1y+N
JGxRQfhJyorRQQTmz+7vJBBt/+ov1/7VdH4L758TQCw2RHjk9melHsjk7h7E/CsPjgDmhPL/
Y+xKmuTGcfVfqZjTzKGjc0/le9EHrZl0aitRysUXRbVdPXaM7XJUVceb/vcPICUlSQHKPnhJ
4BNJUSQIggCYowjuDKLU3g3W1s4oYRzINVlmTppCZelxSsZzFvoo47EBte4jY3+tG/qpE2dW
UacUgSskbxuryj3P6SXc4QpbxV6jz4R4AEpvOSGEaKd84HO04diHXkJTEcN/lHEmXG7HS2F8
AMeyYIgQRgxbWqdgs3yZyZBl6gxuE20VYZk2kmlsFftpHR/dBmsnSZ/vIFnH8xmjfqewY47r
+Ww+51uNumHMF5+oyHj24UjAJBF14JM5DNTRPvr9We4UMChsl5OyvGbw9vTrNSAQaNNu6EsJ
G2N2+GqDUrsMmYAzaFlBK3YRd7SnPQlSxqHiUM6Z6SKCDJ49tzEe6X7EWXEXVe3/Fqzm3CpM
EP5Fy2sLlhfoQXZuw7piXBpMNIbthGkFoxoTJtQ+cxg6ekQZ4dHWwgwY7W13U5lQ0DCbDNis
evP5nLUN94sDOn0n3Hp2lB89b3VhtdFgRRkvVG4D0MQMp57Y8YpPYEzntAoLsxrlFjPGFke2
MR6svCE9+pBVF/ThU7WZreiRCfuIHTNo41KE3IBGQbhbMZtymLMReqPQKxG3gB2l563nbcbs
OGFH0lYHwXpU7Baz5ZydtCUG/jLHznVKpUvSK7SKULCdceNcMFIjXVC+nHFXhPnTPm8omTAI
sTcDGffBKbFWBuktPeYLHHyVIYPkXWG5Lc6JoOwBlTff7CxDmZDzHfOVj4ybiDxe6emKn/CE
YRaippeTWuyLnDZ0BPmFLjTkPsdj6i8vF86FJKXHCjK4g6h0Tlf0IWPdZfoRRPdgTetqZ2eG
aPdQre+fv6Knwz/HXo//enh/AfTzw/uXHvXZ9lRoZDC4ififn36+O5oY8GFJrel3RObRP3OC
FtklbGtlQ1slkF/VqTdnooSQD3+4ZRfZojxwtZ+J/lIuHO/9+QyleSZRRE+QgyhLxnTArfxl
SdMl9wDKpITuajS7FbksUnZUYSavCUmXpioooYL/MLuBU3bBRZVesGXEmCoPjsOJ3rP++Pnn
O3syKvLS9ABWP9skwWAmdOYx9zaah62HSUO3TCF0cOQx88tRW5q359dvGLs0nGK8OU1BpxoZ
W44NNr0tpd9cWK4EXTnO28tv89liNY25/rbdeG7jPxTX6beLT/f4jsHE+AgjByXryWN8DQq/
sqz7PQ0UpXK99ix3gxGkPgb0w4/1Ys64ZwyY9AhPT0PqEHbwc9rOPoBArm2X690dUEhLoQEA
CikXODVgijLO0ex1pyhZF2f/7NPr2Q3V5Hff/1I7kPHwMvZQhYrpkwvD7taTWj8tJQFFs5iA
f8uSYsprDsqyCOknRRIHVrq2Gw9zuQ1J1W47w4Efw3IGSjgtuo36Y4ztYdZyo7aiCQ9HQZke
NGjsxKXpsMtMY/X0RA1BmK13W3qrpBEnCTqFTxvHuwb0HdmKBf02gyyQGNI6AVHRqJwfugLg
+2iBw48cYeem0VQ/2s7tMzdbDqtEk2P5DFqQL9ugzulp0YMEhhwVTOyAC2K8f3uppXIe3C1O
hWlm/iTmChsyzntGI8JsPqOFi+Y36p8JQHc00oaCcUfvejfx1sww6z/PJV3a30dJ+sPT6+f/
e3p9fhC/Fg+950mvbKDvoeFWgD9b4c1WC5cIf3dekTdNRTHC2luEW+ZYRUNg+aXlVMcOhSWV
NDUVAVL/cgurfOacXHHRIIa5VCU9QvZ+FrtxGlrB+/L0+vQJVIBOLzH66GTFHyktSwd86Pgl
Q/id6h5wox3OYxrgbmSMkYq0W9FtWxifjpx3ohZWnIvKTa9r95IuIC8+Ftk4mEw+v359+mZo
vXZ93mI9s8dERxy/XiIuOrAcfrdWGg3zMStC0mKYUU4mI6/axq9qaWQkN9ld9HeHWVEQIruF
wc38/NqqIEKaLw9+FbvhgCZAn7K5SduopsrBgSV/+fEL0gCq+l9tPW5KsVtPlkTtQZJpjDTA
Tv5rEI3v5Bb6gRkpHRt6NYiryGd2Fx2qm3kfan+PX+BvQF1Yv3PLxWXntWV9NQ864lOJwZ19
ChahRn9ox4zpU1L1JFGuyptsx1ynZd8rzBbN0ax7eVtmoj3A5Evt4hQdlh5BxPCbEH2MY+QR
+m6xrcMiJAxXxdhktX4VSWJEq55BPOZRYXmDDUQdiy4KR7KMYE5OpBvDyol0I5+EmXTohG7E
plfrcrehly1UrwRnac/OTjbDW4H+eSpsADOJMQaufK9Tt6h+oM0rIfwp6RZBp4TM1S84OvWF
OUYrs6IoqXEIKp55GBi2Spe3E+8i2Y1gVTS8xwO2ouagA3LWkGoZcLogEvQB6CUOqpiDToBx
7M5xcRk+yAzpX17e3g2fDMogglWAgjRfL2mPnYG/YSwHPd/2ZTK5WbRdb+wO07RWrjxvMeKg
dd8mgj7jUixnYKSg58jKJuXKXr8giVD3zlu7n0EKuV7v+J4A/oZxOuvYuw1tfEQ251/T8cqq
GK3pytNktKKrusJM9H7JOCD0jQoPv8Nn7/AP//wO3//bXw/P339//vz5+fPDrx3qF1iyPn35
+vNf7kgo+M2v6uPQJxNXOp2QwSLKsi+Y+3ys48b/BdXtByyfgPlVj94nba/kRm0XGcM3touc
SfH+GRZV+4UEWc+/Ti1Ap0Azqtvi4v0LNO7WXKPnnS+l8xFYpeponZDNXztA8BaqO5CAsb/K
cqwjliDQCN2kJOWcSstwho288qtSB9L7UhT6qP+mkWsSbaSl4lx18h1M95Bap94mfcLnvMSj
fDe5jyHjZT3B7tLrtJFcbLnoIgPi0ZuQHhI8Lrb/Zez8PSbzL/OtcxA3LMBZkZtrP56RnoQV
F6SJ3XA5iLH9M9de58QkkTEoRpVs/UDUzb6p6MSaIxQlxwdQtF3NV+ZGz6B7FB321os5x1hz
jA3H2DGMJV3HbrGaUYwamks+AYzNgmFsuaK21joysGS43SzIQO8OcfTqOCvHhR7ns45BFBqw
p7M9pL6U9DlXj4jk3GnYCCLWR1iK6UndY5Lt3Jutk7sYb5Ew0SMDaL3crhkh1mNgwc/ojXIP
2cOMZvzoe0S6nnvsVmnALGaS0q97BEpt+sOVxz334USQ+aw9YICUMaUGDoDa21JlfwhX1GF2
z06zzXLc1jTb0lRiUgJ1S1KJKZ9mHjFPgErW5pG1eWRtO7LcHTFdgbqkOiqtoacY13QLs1pP
9uduvVjNqQpQ2G/mtDHRwGw2zJHoMJBCb7tk1icTs1ps72ASb72bnupTOu+AyTJo87RQyeL5
djndnDgL56sZvZEwMIv5HQw6oqy22Z336kA7eg23YcFyN910P5KgDdCxuQMmCzfeHcFaH7Lw
zsevsxJWunuQ1exORQC50xZ0zQjLBkXWPdzG20yL1lM9X8zvVFd7i+XUenj2lltvHo3nMzJ2
LGPBMQiJA/R0661rybE2+Z5kbRbbQ8JxYsUavfAh8rnL23pRIuSSPTEahhUeYsnMAlGbQ0IT
OM7mrF3/1oL0NFuQSYTc5I194m6tuBqqe2/foj4ueoncbm7VluqXH18/vT3Ir9++fnr58RA8
ffrPz29PP6z4QympSHe0no4vNwaispqa538IzNbMJDnUuD+UIqTlTF1KkNBMfBGWXGdMwgdk
njNvxehoyAaZvJ5tlnTNfnBZz2ajjWHHTTHdhDJ8WCVWUbjkYsGQ/8HPP+IFAlwulyreYyo3
LsdGHIGc6Dp9NAb3r08/v+DHJHaV/p7KHnDaY3Ch4eTWEXBhhM1kIzFPwVAGMuVZwPCKK8bP
MWKMEfCousqaZoooLvqbxIGGnjMkMKGV4EBlGsWbbdMwYnsn+voGA/sv1lUmErLE+zn7If3d
fuxLb+RzvLrClx9vL9+eMRuFLr6L/XCLx84LR2dXex/+18oiweB2dBjCd7nH79JEDIcyKm6B
PJEompwSJgdBzNyDmV4fflT+uZcRaHIxXVzM9DogUg7ONhlKLwV5/6MGa/cfLX1+Pn/Cgxqg
UtITi1pmME0p6z8y/RV6Nri1+2HVXNok4R5CIW69axvE6VHkbjkhmuSZQnASVFe7lPAg4JdL
1MGvbtnQv/sir7j4Z4Rgen6f2oQo5sdj7NR0vMZuLftrxSd5RkB9FvnBp5wXVImwMol8X1um
EREpRxa343ua0+8Wv2oyWHpKP1pMofa71Yz/eiqWFmeE+65ZIekzMM3E8yHVY9ZDIGyY7HrI
hQkS0+4KapD7Oa7CacFlG0VMXPvplfFC1zMlLEBssfzHBmqh9T1kV0UYMp7/N3Z75BLhKUng
ZxjkwfNhSPNMzO3R0EJfi5kcY25Y/h5dZ2D1599QZvBVPxTXyWLqopQxk9FN8Q9VI+sMFiHu
oAtAGJI4WcvHa+Qzgdwo2kYiFYn65nXM7hFGDKewslFYrNhlmeMXkVwApyolz9V1ECr+4xbt
pgPDvr59ev6Git7Ln29KwI+yt+ri8Sk7QdqN3oYpfc2uglxzH+Yq3ilRmHeBIU/bWq0Sz45d
f8Rsw8AfJ4XDpw54tHZLBWI4YFqFhJvtBfS5Q8gtTRdMAYKfyWlaT9edvaevi0VgfCvApVZ4
3c+hCdraGR+KW9f4jaR7VQTyi0sDe/BD6bbbAoHqMp9vLncx283o/UcY2ERN9FHB9JGiB/Aj
zkFFzdWFbGw1LjhzVHgXmoq6TuMObXdfw7RHpt58PvmuledvNuvddhJ07opnAYez7/LNcAE1
NF9eH/ZPn//9/H5LAKVDBcQPvIn59cmYe8Og7pyJw29Pb2+UaqQmeEgLXhUNoB00+DeLKLsq
cuos7JXfvKjj/3lQ/QlbEn8fg/b88/nH57cH2CqqDEy/g1J4y1X18P3pr/4lnr69vTz8jiHP
z5+fP/+vemGzpMPzt5+YZPvh+8srZur548UWPR1u9GE1eeJQykL5tZ/4vGDpcXg3Iuc8YeKE
jBbMftKEwf+ZRdlEySiqGG9HF7amDX4m7EOTqej8u0BQKhsm4Z8Jw/SqrLeuCTz6FZMgxER1
ajAmZgj575GKoJGNHYp624J8f/o3RtzcnAqtZ7Mo9Ca+jdIbHXVuKJqLUdFxMXLLhHmpF1Ru
WGSp9iLLFB9nYkNbGDvugnbJVwIgauqG1i11004y5idJJYr1RIel8b6o2dNbhZgQjCmjjamV
uBsL4XUbMr4sGqaMXPxqFSmHb5af1JFQ3u98/+FOsNv4870oJPwDW3H+XflXRd/WEJSloGKN
OupVirNfwffgEXXMJP3T6zaaPxLalxcBez/ax2ObSFHv1V1Dr8/fnt6fMW7nj9ent/fXPz/h
9a9WEuOi1LpQGAs6PqY509M6y5iQgjjj3e9RY4Uvw122glfdiECkXByjgL9zEfjM7Udx5FOX
pVZ12GqHCoOgVFybdAjrQl5pYqcZ//aP1/dPMyNBL0JGS5bq4Aoj/oh4KXwClvBEX4NkV6bo
Ku3FmKytK1bFPb1t8D6RrKGta6qJ1Wk00ga3JmwpIcT65yI5X87okxsTwrjdG5DNlpaHN8hy
wQSk9xA82OPCqntMJdfh8k5VQqbzxYw+arIxi+mCLgCh1/Aeoc4HGWloYbxpTLaa10ziqh4S
PC4X9LzrEXK5Xu6YE/wek2TLOeOAN3TxBZpLm/0NyMzOGq8Ng6Vwxpv2mQI5hRezODynzDAr
pDsHurG18OjV1ICsmbMzE7Ke/gYA2a6mB4Ssj/Nt7U8PrWzl1XcajBDGX9SEMCF7A0Rmm8Wd
FgePK485Cx0+ZrkOmWOeHnJazmxlSn3Xlx+/4BVXjISJMp/IIHxbD5rL5BrOHLXI2nf38gNP
3TfWeVdS2YtV65Kvr9/VkQBhcIgjagc9pHkfXysaYRKeKqAdw6IwCnz65aNMCHqV08lrRZBg
LnoiW1yCtxxpJ1RjDsWXetGa601HaC+YV3ZMLgspLrAkp2OWjMOmgiXafM2hNDKbNXCXbuXL
/qIUidcqFlUUV2bMSfcI0bwl37yl07wbZ+VWv6ILX/GFrybefcUa7D7Ywb3wcwq6cLALFowX
GQQqvbclEWMB+5ZEtsz9iR9GrFtxxFtfFNz+/dgUZpbjC/+k7euPFH5zv0/kgms03jXJMoN6
4nVzkY4fHeZsijfOhkcrW3UiddI0I6jGJYgurRomwjMe9AfcUH1P6zRbvCo0ExJT1FENcjpW
/ewTk1vXaQ/lK1tQBwTxk3NSTyO4kaS5dRVbNplHvJLsRLmSaI7hEqYKsHK+9ZRbeIYh1OuC
G4Sap6bqUHiCob8mIcR47eFXlwuyG3xaUj99+mIq3InU0+S7Q8CForb0iZ5xELIu9pVPb1F7
FD+Ye0QR4A1+6P9BHV8pDI5C6wzxRp2owACRbdX9oHLP/xqdIrUkjFYEIYvdZjOzOvdDkQoz
pdhHAJkCoIkSC4+/83Q4fYgK+Wvi17/mNV1lgtfSGY9nEp6wKCcXgr/7G7Xwcnm8hfu31XJL
8UWBoT8SXuAff77/4Q3XwcA2qavlJhlqShyZzGo4Ji/fnv/8/KJuDxy9UXcvwK2Hbhe/OzTY
7llzRBHxbfoLgoyARHtn2F9lY/60ZO7wVodmD/IiYKRhx1WVUuNR/ZPY30Nd86BG2lXWsLO3
pnLES14/4XmxSkHKcQ/8g8BSif64pSDmHw0mmsOz0mJPCqoQ5ps9nuRj48sDU8zpwleRiRy+
I7fyZROdUfK8x/yy4oRs1RV6+8aagh4ocdQG1y455182u8gH+u2lr/LENaHh6u/voLMHVc90
FA78fVq6v21VQ9FWVgYvRWmpxUud1+X2wSfCcZXpImMjcnXuQfoWJwRZLYjsX7A+jhoZuW8S
3V7FbAuQqcR42PlGLeqnfu9BDcVTarf3oPzxATYydL5AQ+g0eVWG7u92b1nJyhAUYKS1xyqw
L9C7sWR5zBjn4izgxksYlwd6wITC/lz4W6/dDLg9x/6xLc/93aD2k00Z+il1DZfiOjsCRVOi
dlSOWjyomADNHWoaPQjfCVQWvJCVSc2ZhyXbS0Xk8yLXnXF69Xp6ff+Kx5AP9V8/Tb2o9Kta
oBPRcMmlJdxhCctvGFo8yeQOws/E3r+Hqf1K3MFgkksSYSkSA8J8kQAmVCTkkb85U4tg2QTT
bZBFCg2V2oYwicTgfGUOmK43jbI7Bcn9vY4BtaeCxt8pprn3JdVZ32QPg7pJ9y8uAhtv8lmt
Id5+9Aqbq6alclDxWlDxbiuUxdnyHDOwxuJ46xnLWbAcvjSuBd6GrWczZzlsC8ygIoezYjls
qzcblrNjOLsl98yO7dHdknuf3Yqrx9s67wP7Ds9b71qPeWC+YOsHltPVvgyFoMuf0+QFTV7S
ZKbta5q8oclbmrxj2s00Zc60Ze405lgIr60IWmPTmjoxPkGUZtYPvQj2+6Tj8+uP528PX54+
/UdfldpvWCo/VClhktTfS0MbsQ0ZOuUEJXpyTNelLBxQYVnFoV9bpkLNzxpZtyp3hWGVAUVd
P/nbYrbyhuXC3wu1I1NpanpBBpK0hLGSAcPUSZscExAiMShSK9sKBgzbukl387tuBvEq+hmt
Q9pWYqTLg5MVx9iIhMem7HLnsHfJVtEEbqhJpd85NDl8GF9a+ry6D93HCwsHts7UQpTDYtuT
nzbxb7OhW9H7bRgot2UDyZwWp3KPjO0zupe0VYUJ+kmboIcxayEiRvU6VRxVHk2fPkvTkKqG
AVfHF+bsomerU9fJu1tlKXI3Y4oDmapII7CAFpRNJu96WRWnwdjJDrCWTTZutxT6MI7pcLZb
awRenl6KVsZpgn1AXrRXw55TSYfxVz7qz8zOIfjTXS/nzsguSYxTHlLbKo6akLsgWsGYLBUd
U1R1wyjtGnGu0FfevWDY/phxVlRXddneuJWuqdD9AvTH00xlaxYxc0dgl94AegA2HsJPp5NR
aLmpkk/GlW0jNTm0qQW32J1EV5e20BMkbFqQUHUDajLrA4OgsGxwoKTptPQL+qGkRhxfZDd6
1DjGe07wWugJoMpk020oQSThYSY5fY4Rcx88Nr//MvoiRPj07sg2TgyUHVMBOF09hdUvD6/O
1XE3bRzt7vgPdlm/HDpvhXrSSFr0y53UonfozpHxoCj1km7sk9V1r0mTq1bf4e4rH7b6fweT
lOo7TlbTZmq6UcDeUz3pRYxVivU06BRFFTmQvhMVUo140xSCAk5fwGtoIuqGcMRbh0rwT41j
TQfZjV59hO8PNRjg+JMkIyHqfAv6ILl6lEWSTEH04j0B6Lqx6ypKqAToKXfAJUiduOVF7pxh
aToGNWAkYdQ9wCx3/1/Y1ey2DcPgVwn2BE26FtthB/kniVDbcR27TXMxsixYg61N4aSHvv1I
WrIlUepOQT7SsqwfkpIocmCHfvmUkUawp+a6Vsq3Wa5a3nbqm2pY0jZlWJSgezux+mXXOEDa
CCbsMheVX8mjdpZJSj7xmAAK/SJIP/jlkhrV4dMhfBxVb5hD1Cso4vbroJ39TShyvBXtaT2a
HqQt7haJFakI/3/+AOg/JpUG0GskwFQgOW1FycRdGJ1fFjVOY8TDpLiaSgVZB/UG3ibR4jMb
hsYPJsjGzC3/4wOhKQJJG5TA7XUHLDwCt9VpU6lOmtwn1JXFuUqcLLwm/j+NV2zCHHKV580n
w6WnQ0ek3ltB1LnDZODSCeYY2QFt/VSm7dXm29W4OnBpsK6b+mlNnwBu5qeSWLlmNHqZGaN5
JATMwIGjCdsuA0/h3L8bWlyfRxpVhG92jRAylHANFdjsLcOH9hgtLJdbjI+ZyYJFxu1HJk0c
0ufxqnzqjQFPCvPD/r07Xj74TTEMEj12I/7Tw5kOOS0q97rRyNzDpU+BPBRKFWiF1a5T0MGb
ULBU9RhIMlkEfOYHJhB7q6eA15jmESV0SR6wMqV9I8Lp76GMRBgHKS71x5dhx3MD1iCZokYT
UZZ0J0Jtj6GQLJ9cdGOl1iaovHcRTDF5S1aO5URsEl3poAchntUOYTHj7uPtcprs8WrPqZs8
H/6+HTrTP65nb+fSG+1OUUW2EGb6bwuecTwVxtU7A+SsoNZjTGhShSn8IXVMxEHOWpmhS0aM
M5bo+cJYCeXMuShAffA6Kzz4AJ4v0NYXLbAZ12I+nX3Lm4xVo2gyK5D/UDv8DXcbTtj7Jm0s
Y0nR6MfnGqm7q6mXYASxqpDZrm6liffL8+H1ctzTnYX0dY+DDQ+uKOO2OJ9P+yORkt1lN0op
XYM4Z6UvPNg6vZcP+pXR39P+z+Tl9Ms8GNMFRjFr0riuWIGxGelGYWkcMSyrHj0DIuJtsqEC
VVj683OgemBP8vptfOU9IOcQ9uL34Xzh31rF1zP+ZA+rWMescWneuGiefOXDNbnhmIyXAgQ7
/PIZlScwcr2web4ywjMz+O0IX88493oppj7QVwTAN9MZH7OLavqdw49lz+xODWqnNs5gJraF
7BuTKeH4+PZs+bwPYo4PLsDIXqQzIPdtSPS9xeEqmkh6Sq5i3nsRZTXzdHUs8jTLpPAQ1vWN
F+VtnKRccM2dHMUKvluKrUcTrEW2Fr6e7vGxqVw5kHrKSqsScwpzMcW/EgwYb7MoXDtYhMhD
tVS4mZe37nA+g7hjYwAMCNzzYSVt8VITkzLblS6z2r3+Or1MiveXn4euT8G9u/heIIq1BGuz
spPiajnzGDL57x6sGOZqd1RuWWQSxRDJQlRq/TXXFkV2/Nntuo9Jd3q/HF+ti1Jklpi2TCRh
CYKJfw3TSO+VoCs8+uGva2QL0AvchQmTM+E+DQIQFIusrRERT29tjnp6lci5jcm6ae2nri09
HhvnfdCPrgDGvsU9a7vjCWXDAbqcHG1VOBoDTVKOY/gJCm9v7nYh5IQNEhhv0IxZnynXmH+M
yKGM+sYAAA==
--------------060307030906080303070107--
