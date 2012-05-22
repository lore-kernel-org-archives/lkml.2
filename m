Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab2EVPpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:45:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56238 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467Ab2EVPpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:45:40 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 17:45:39 +0200
X-Google-Sender-Auth: -7busc5c40yzirHtLeMydEj5joU
Message-ID: <CAACrLC39Xdm3vTKUsjz43ZPyEq_vHxR-_Uf56SjSm+kUqxOqZg@mail.gmail.com>
Subject: Using jiffies for tcp_time_stamp?
From: =?UTF-8?B?U3JlxIdrbyBKdXJpxIctS2F2ZWxq?= 
	<srecko.juric-kavelj@fer.hr>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently I tackled round trip time estimation of a TCP connection.
After implementing a straight-forward approach (time stamping sending
and receiving of data using clock_gettime) I found this article:
http://linuxgazette.net/136/pfeiffer.html (using getsockopt() to get
struct tcp_info). The tcp_info structure conveniently has a rtt field.

Using the first method I get 1-3 ms RTT, and by using the second I get
>10ms RTT.

By looking at the code it's clear that the time stamping is done with
jiffies, and my kernel has CONFIG_HZ=100.

I understand that this is for performance reasons (and the RTT
smoothing filter is implemented with bit shifting operations), but
would using a more precise time stamp have significant impact on
performance? Since RTT is used to compute RTO, wouldn't there be any
benefits of having more accurate estimate of this value?

Best regards,

Srećko Jurić-Kavelj, dipl.ing. (Ms.E.E)
Research and Teaching Assistant at University of Zagreb
(Faculty of Electrical Engineering and Computing, Department of
Control and Computer Engineering)

E-mail: srecko.juric-kavelj@fer.hr
URL: http://www.fer.hr/srecko.juric-kavelj

Sanctus Hieronymus: "Parce mihi, Domine, quia dalmata sum!"
