Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310Ab1CXPwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:52:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55686 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab1CXPwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H1xU5pNMsECWEoLW/zAR8nYxsxSx0/zBdqw0wA2cOh8DTS9EL1uTszYUQEFii8Lj5j
         E4N81SwYRNiA2xCBiBXGQfzndefAtt1agsrCSKWc5OVgQDYBIM0eRtv5FNzjld7K8xjX
         l5Wqc4yiiq4lCbE0pl8TBZ6jzTj7QEGQK8Sc4=
MIME-Version: 1.0
In-Reply-To: <1300980118.3747.42.camel@edumazet-laptop>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	<1300980118.3747.42.camel@edumazet-laptop>
Date: Thu, 24 Mar 2011 16:52:41 +0100
Message-ID: <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
Subject: Re: regression: ip r change mss doesn't work in 2.6.38-git14
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 4:21 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 24 mars 2011 à 16:08 +0100, Alessandro Suardi a écrit :
>> After fixing the display issue thanks to Chris Wilson, I now have
>> another problem
>>  (which didn't exist in 2.6.38-git2); most websites outside of my DSL link don't
>>  work properly (connection packet goes through, but the page load times out
>>  within Firefox) unless I do
>>
>> ip r change default via 192.168.1.1 dev eth1 advmss 1400
>>
>> This however doesn't change advmss anymore:
>>
>> [root@duff ~]# ip r
>> default via 192.168.1.1 dev eth1
>> 169.254.0.0/16 dev eth1  scope link  metric 1004
>> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.8
>> [root@duff ~]# ip r change default via 192.168.1.1 dev eth1 advmss 1400
>> [root@duff ~]# ip r
>> default via 192.168.1.1 dev eth1
>> 169.254.0.0/16 dev eth1  scope link  metric 1004
>> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.8
>
> Indeed, we'll take a look, thanks for the report.
>
> In the time being you can do :
>
> ip ro change default via 192.168.1.1 dev eth1 advmss 1400 mtu 1500

Thanks - this one works for me.

I'm available to test patches if needed, though I have a feeling you
 already have a handle on the issue and won't need that ;)

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
