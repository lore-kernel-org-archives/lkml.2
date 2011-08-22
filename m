Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab1HVAeL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:34:11 -0400
Received: from mx-s.ctc-g.co.jp ([131.248.58.2]:46872 "EHLO
	mx-s.ctc.ctc-g.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1HVAeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:34:08 -0400
Date: Mon, 22 Aug 2011 09:33:52 +0900
From: "Jun.Kondo" <jun.kondo@ctc-g.co.jp>
Subject: Re: [omega-g1:11072] Re: [PATCH] net: configurable sysctl parameter
 "net.core.tcp_lowat" for sk_stream_min_wspace()
In-reply-to: <20110819.024326.598275465899000817.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, omega-g1@ctc-g.co.jp, notsuki@redhat.com,
        motokazu.kozaki@hp.com, htaira@redhat.com, netdev@vger.kernel.org,
        tomohiko.takahashi@ctc-g.co.jp, kotaro.sakai@ctc-g.co.jp,
        ken.sugawara@ctc-g.co.jp
Reply-to: jun.kondo@ctc-g.co.jp
Message-id: <4E51A3F0.5010500@ctc-g.co.jp>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
X-post-Received: by post01.ctc-g.co.jp (CTC-GN 2006/10/01) id 62D5A74DB;	Mon,
 22 Aug 2011 09:33:52 +0900 (JST)
X-vs: by localhost.is01.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 42A8F5BEF0;
	Mon, 22 Aug 2011 09:33:52 +0900 (JST)
X-vs: by is01.ctc-g.co.jp (CTC-GN mail 2009/02/01) id 35B845BC14;	Mon,
 22 Aug 2011 09:33:52 +0900 (JST)
References: <4E48B0C3.2010203@ctc-g.co.jp>
 <20110814.224714.2061635645365376268.davem@davemloft.net>
 <4E4E2CCD.6050809@ctc-g.co.jp>
 <20110819.024326.598275465899000817.davem@davemloft.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.2; ja; rv:1.9.2.12)
 Gecko/20101027 Thunderbird/3.1.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By using this patch, we want to prevent "timeout occured over the network that is low throughput but available".

But in the current implementation, both blocking and non-blocking,
user processes can't recognize the reason in detail
when failed to write to socket buffer, we think.

is it (really) network problem ?
or is wmem not enough free to write?

As stated above, we think it is difficult for user processes to handle timeout of writing socket buffer,
when wmem is configured large value.(to ensure high throughput over the high ralency network, like 3G).


(2011/08/19 18:43), David Miller wrote:
> From: "Jun.Kondo"<jun.kondo@ctc-g.co.jp>
> Date: Fri, 19 Aug 2011 18:28:45 +0900
>
>> You suggested to use non-blocking writes, but we think
>> we have to rewrite the Apache code if doing so.
>> That is, we have to make a modification to Apache that
>> depends on the architecture.
>> By using this patch, it can be handled by changing the
>> configuration a little bit on the kernel side for such
>> applications that it is difficult to do so on application
>> side.
> The kernel provides the facilities necessary to achieve your
> goals.  It is a userspace problem.
>


-- 
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
近藤　潤
v 伊藤忠テクノソリューションズ株式会社(CTC)
v システム技術第1部　技術第4課
v 個人:03-6757-2144
v FAX:03-5800-2256
v
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
