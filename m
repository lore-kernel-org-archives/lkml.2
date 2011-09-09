Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab1IIBeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:34:16 -0400
Received: from mx01.ctc-g.co.jp ([131.248.58.1]:63632 "EHLO mx.ctc.ctc-g.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637Ab1IIBeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:34:13 -0400
Date: Fri, 09 Sep 2011 10:33:58 +0900
From: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Subject: Re: [omega-g1:11110] Re: [PATCH] net: configurable sysctl parameter
 "net.core.tcp_lowat" for sk_stream_min_wspace()
In-reply-to: <20110824.220016.781758659534965980.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, omega-g1@ctc-g.co.jp, notsuki@redhat.com,
        motokazu.kozaki@hp.com, htaira@redhat.com, netdev@vger.kernel.org,
        tomohiko.takahashi@ctc-g.co.jp, kotaro.sakai@ctc-g.co.jp,
        ken.sugawara@ctc-g.co.jp
Reply-to: jun.kondo@ctc-g.co.jp
Message-id: <4E696D06.3000003@ctc-g.co.jp>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-post-Received: by post01.ctc-g.co.jp (CTC-GN 2006/10/01) id 42D1D76D6;	Fri,
 9 Sep 2011 10:33:58 +0900 (JST)
X-vs: by localhost.is01.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 1F9855BEE8;
	Fri,  9 Sep 2011 10:33:58 +0900 (JST)
X-vs: by is01.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 141835BC2B;	Fri,
 9 Sep 2011 10:33:58 +0900 (JST)
References: <4E51A3F0.5010500@ctc-g.co.jp>
 <20110822.113544.28950168095176936.davem@davemloft.net>
 <4E55D3C2.40308@ctc-g.co.jp>
 <20110824.220016.781758659534965980.davem@davemloft.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; ja; rv:1.9.2.12)
 Gecko/20101027 Thunderbird/3.1.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The client of this system is cellular phone, and the
status of the communication line with a client varies
widely according to its place or congestion situation.

In terms of the line speed, it can be around 9Mbps
when it is fast, but 8kbps when it is slow.

Requirement from customer is to provide stable service
in both situation.

- In normal situation, acquire large default transmission
   buffer value, and ensure high throughput from the
   beginning of tcp connection

- On the other hand, even when the connection has low
   throughput, such as low rate streaming, transmit data
   without timeout

However, when the throughput is low, it takes much time
for the transmission buffer to be freed, and timeout
will occur during that period.

Of course, the connection will not be disconnected when
the timeout of application is extended, but end user
would not wait patiently as long as 1 minute.
Therefore, we do not want to extend the timeout value.

By making the threshold, which makes write possible after
the buffer is blocked once, configurable, and set it to a
small value, it will be possible to return data to client
without making timeout occur.

So, we think the issue can be solved with this
modification.


