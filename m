Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0LHGFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 01:05:42 -0500
Received: from web31708.mail.mud.yahoo.com ([68.142.201.188]:35190 "HELO
	web31708.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752687Ab0LHGFl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 01:05:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=6olrGEknFTW4ZTFK9NCi2re2AfX9OAIoUGlawf1jxdl1C2HRrltbTTLiEruuJMs3g0kIKvCb9fRsSRH1ms0mxGDFTGo/icPJQ7UxWitqCwuH2UrTHyiWlHaewakWSCwpjlmBvNupZx4FmA1UM4esk0OCSk9LrnMSWR9+eR+W4a8=;
Message-ID: <241570.15232.qm@web31708.mail.mud.yahoo.com>
X-YMail-OSG: qE0C9AoVM1lBlh7Bq.QaqqYqgG1b4MwxYdZwapyIWMASn8Q
 poj_zUkMwK51GoMAp2xgBtV1YsryP2Xwu3bH8Nwsiyrh3CNKNxckzGdgWu7g
 dym63ILhYwXyzj8omSWy508cCgjXJRlKStb5Ok2uHmGvPBm6O8MEmDZyF1dT
 KPnypBav0bM52htvXUkIQcZkGyCQuK3q8K79SY_2SNh1lEVkM7S8cXAMSLw8
 hXOwCJ5CRlmhPYXI9M.r20zyQrf.QwMRr0pmmG9iGotv1PDbv5rHfCODxvV3
 YaYsbkUx1XxhRZd5Ka3h1a7g0oMwcDKyNSTEJWDb8GC3GgFnzrW2.BcC8MC.
 VYmBSgMhl.Yju45s.fg--
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
References: <712019.56679.qm@web31702.mail.mud.yahoo.com> <4CFEE38E.3020500@gmail.com> <597621.83948.qm@web31707.mail.mud.yahoo.com> <AANLkTi=V_MD5MqkPfBSD0P+J0vYgS3nwHZA37SOvYW-Z@mail.gmail.com>
Date: Tue, 7 Dec 2010 22:05:40 -0800 (PST)
From: Sanka Piyaratna <cesanka@yahoo.com>
Subject: Re: Posted Write onto a PCI end point device using Linux
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=V_MD5MqkPfBSD0P+J0vYgS3nwHZA37SOvYW-Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for that Robert. When you say DMA, this has to be implemented at the 
endpoint device doesn't it? There is no DMA mode on the CPU for doing this is 
there?

 Sanka Piyaratna




________________________________
From: Robert Hancock <hancockrwd@gmail.com>
To: Sanka Piyaratna <cesanka@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Sent: Wed, 8 December, 2010 3:25:47 PM
Subject: Re: Posted Write onto a PCI end point device using Linux

On Tue, Dec 7, 2010 at 9:57 PM, Sanka Piyaratna <cesanka@yahoo.com> wrote:
> Hi Robert,
> Could you please tell me how I can initiate a posted write towards a PCIe
> endpoint with larger than 32 bit payload using Linux?
> Thanks and regards,

You can try writeq to get a 64-bit payload, but I don't think it's
available on all platforms. In particular with a 32-bit CPU, it may
not be possible at all. If you need to send bigger payloads then you
need to use DMA.

>
> Sanka Piyaratna
>
> ________________________________
> From: Robert Hancock <hancockrwd@gmail.com>
> To: Sanka Piyaratna <cesanka@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Sent: Wed, 8 December, 2010 12:16:54 PM
> Subject: Re: Posted Write onto a PCI end point device using Linux
>
> On 12/07/2010 05:29 AM, Sanka Piyaratna wrote:
>> Hi,
>>
>>
>> I am wondering whether it is possible to issue a posted write using the
>> host
>> computer's root complex towards an PCI express end point. I have done this
>> using
>>
>> DMA in the past. However, if posted writes are possible that would save a
>> lot of
>>
>> time and effort and would be quicker too.
>
> Writes from the CPU to PCI memory are always posted. However, the posted
> write buffer size is usually quite limited and so this probably will
> still cause CPU overhead when writing any significant amount of data
> this way.
>
>



      
