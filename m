Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab1CXPWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:22:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57449 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab1CXPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rC1+fEN/hiNwwAsHRC56AxhezshZ95PjNMv/XiIbasy0gZF7dnXN6hTzcwCIcu3zKp
         Hajxz+fgi+nMzRqXaOdeFkIdpIY3M4/u32UPseWX6b7ZpwCSaDUE1s2WHXgHl4E9rUWj
         c97iU1jKhsbGSM2Rkb7RODQsB5nUuaMGf7vC4=
Subject: Re: regression: ip r change mss doesn't work in 2.6.38-git14
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 16:21:58 +0100
Message-ID: <1300980118.3747.42.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 16:08 +0100, Alessandro Suardi a écrit :
> After fixing the display issue thanks to Chris Wilson, I now have
> another problem
>  (which didn't exist in 2.6.38-git2); most websites outside of my DSL link don't
>  work properly (connection packet goes through, but the page load times out
>  within Firefox) unless I do
> 
> ip r change default via 192.168.1.1 dev eth1 advmss 1400
> 
> This however doesn't change advmss anymore:
> 
> [root@duff ~]# ip r
> default via 192.168.1.1 dev eth1
> 169.254.0.0/16 dev eth1  scope link  metric 1004
> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.8
> [root@duff ~]# ip r change default via 192.168.1.1 dev eth1 advmss 1400
> [root@duff ~]# ip r
> default via 192.168.1.1 dev eth1
> 169.254.0.0/16 dev eth1  scope link  metric 1004
> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.8

Indeed, we'll take a look, thanks for the report.

In the time being you can do :

ip ro change default via 192.168.1.1 dev eth1 advmss 1400 mtu 1500


