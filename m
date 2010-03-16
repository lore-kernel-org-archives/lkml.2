Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966240Ab0CPOB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:01:57 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39236 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab0CPOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AxtchrA6Sx21AaROFctEa9x67xKp+K/E7ivarVEcwKhvintiR86B1Tt5xK8P2h1Yhc
         U3epwIqagS5vFb3zqA+3vS+X+VpqnK1vzf5hjl5T6Knk29lazgBmmrdkds/VaAWPM9QE
         HCBjJsBGsTLuFGZHKiPgyv28LEh+4CJ/G/irc=
Message-ID: <4B9F8F4F.7010103@gmail.com>
Date: Tue, 16 Mar 2010 15:01:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.4 Thunderbird/3.1b1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: locking issue in vhost_net_set_backend
References: <4B9F8E7F.7070709@gmail.com>
In-Reply-To: <4B9F8E7F.7070709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 02:58 PM, Jiri Slaby wrote:
> I don't see how the lock is unlocked on the error paths and as it is not
> on none of the them maybe I'm missing something?

And there is one more issue in vhost_set_vring, several returns from 
VHOST_SET_VRING_KICK, VHOST_SET_VRING_CALL, VHOST_SET_VRING_ERR with the 
vq->mutex held.

-- 
js
