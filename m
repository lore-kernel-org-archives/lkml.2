Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723Ab2CNKWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:22:01 -0400
Received: from nm16.bullet.mail.bf1.yahoo.com ([98.139.212.175]:42596 "HELO
	nm16.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760682Ab2CNKV7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:21:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 869733.58020.bm@omp1043.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=lMQNmEZ4eAIzzPxMA9MEeuulL4aPmiOya1FPG74aEyb4g8NLMFA1D/SmW98nChZjZW1Wt19U9lgTqbAvnab4BmwcInL40tSARQS3haNwC+HcM0TfpP+m97o7PabCwayuk9JJJG543Oxov12ZTrC/ekLNheJTuy22VcIS8Aa3V7M=;
X-YMail-OSG: tWsSqi4VM1m1NNqHMtPpFQ2jvUCKLIKpntxTEzoCHX25uhW
 amkkNDYhhvslj_.yKjofuCcECv_v9T1N7ERfG6GvQRUM0rlUfnKRSausXIPt
 vW0x4FlRHTIzuiuyv5CRMzzYy6V9R_GUSoiixc0lgrSMJNokY1BYrtomPovO
 DFQowlSqIcdsGDhZ55x9RZy73NPxkyc46_HYxfDGNRH.kIogN1MY7xkUH1u_
 Sz4mC1X__j.MNr9CwG3jevTAgg1LoZGVOyMLsexDH53f6cwtaRtBrRbp0cLB
 w.9pVVVICCsRbkRg.LXT8p0pDiL8OVAimDQaLcmTqvjhNJb0SkG6HXdIhDiT
 wBxOxwmxDGTVjzCEoziuY12uHSucW8gsbEn9FqCI1IbUKZ2ml.OV75cijywM
 ByEkVFb2KSDgSd3OPTWkKB5w755ydQPF0ESijSMWDphj8D2ccTsWFnjmOUPJ
 s1AOT3pUFMHirG7u4OwksZj9GwvvNW_ZcRKdRLj6rZ3vp59VPMBYKXA--
X-Mailer: YahooMailWebService/0.8.116.338427
References: <28119509.96581331614425960.JavaMail.weblogic@epml27> <201203132136.56353.rjw@sisk.pl>
Message-ID: <1331720518.14716.YahooMailNeo@web162005.mail.bf1.yahoo.com>
Date: Wed, 14 Mar 2012 03:21:58 -0700 (PDT)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [INFO] : Hibernation and Resume between 2 similar devices
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <201203132136.56353.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>________________________________
>From: Rafael J. Wysocki <rjw@sisk.pl>
>To: pintu.k@samsung.com 
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org 
>Sent: Wednesday, 14 March 2012 2:06 AM
>Subject: Re: [INFO] : Hibernation and Resume between 2 similar devices
>
>On Tuesday, March 13, 2012, PINTU KUMAR wrote:
>> Dear All,
>> 
>> I am just curious to know if it is possible to "Hibernate in one device" and "Resume the hibernated image from another similar device".
>
>Not out of the box (you'd need to hack the kernel for that to work I think,
>at least on x86) and the devices would need to be _exactly_ identical.
>Moreover, if there is read-write mass storage in them, the filesystems on
>both would have to be exactly identical as well (including metadata and data
>layout etc.).
 
[Pintu]
I wanted to try this on arm based Linux mobile phone.
I have 2 exactly similar mobile phone.
Here exactly means: 
hardware is same, kernel version is same, platform is same, filesystem is same.
The only difference could be some user space application state.
Hmmm.....the metadata and data layout within file system....this is were the confusion is.
Suppose in "Device 1" during hibernation, I have a file say "file1.txt" opened whose inode number is say "123456".
This opened state of file1.txt will be captured in hibernation image.
Now assume that same "file1.txt" is also present (not opened) in "Device2" but whose inode number is say "567890".
Now if I reboot "Device 2" and try to resume from hibernated image of "Device 1", what would happen to "file1.txt" ??
And similarly other senarios.......
Will resume work, at least partially. Like discard whatever is not relevant to "Device 2" and continue to load others.


>
>> Suppose, I have 2 exactly similar device (Laptop or mobile phone) with me.
>> At one time I will be working on only one device at a time.
>> Suppose I started my work on "Device 1"  with few opened application and later I wanted to switch to "Device 2" which is exactly similar to Device 1.
>> I thought to hibernate (suspend to disk) the Device 1 and store the hibernated image as a swap file and later transfer to sd card.
>> Then take of the sd card from Device 1 and put it into Device 2.
>> Copy the swap file from sd card to Device 2 in some swap partition.
>> Then reboot the Device 2 to Resume from this swap file.
>> I will get back my Device 1 content in Device 2.
>> 
>> Hope this is possible ?
>
>It may be possible to make it kind of work, but I wouldn't recommend it to
>anyone.
 
[Pintu]
if this can be possible we can derive many use cases.
Till now we heard about hibernating and resuming from same device. And also people uses it rarely.
With the Tizen coming up (supporting multiple devices) we can think about it.
Also if "cloud" is integrated with kernel in _future_ we can save all our work from one device in cloud and restore our work from cloud in another device.
I think that make sense.


 
>
>Thanks,
>Rafael
>
>_______________________________________________
>linux-arm-kernel mailing list
>linux-arm-kernel@lists.infradead.org
>http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
>
