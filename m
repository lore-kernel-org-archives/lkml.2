Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1DOQdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:33:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60192 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1DOQdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=cVJhur/ecsXZiy77Ca4qGRlvJRGhZLo4ZBUWkX5oaL1PyIpmYN3f0qy3EPeJgMAl54
         f+W1W6n7A4eB+RLNNObNsnoxm9Kuc8hPJwAUq3q4nqB1G/VGzK1D2CwgivVrkBrBOTV3
         EWoW3DDFkaggnMX3qLxLY02RoQ6kPTZKwm/Z4=
MIME-Version: 1.0
In-Reply-To: <20110415162938.GA11454@atrey.karlin.mff.cuni.cz>
References: <BANLkTinj3y+-VhzFAPz8Gzb5vAbtUFU6Aw@mail.gmail.com>
 <Pine.LNX.4.44L0.1104131757430.2005-100000@iolanthe.rowland.org> <20110415162938.GA11454@atrey.karlin.mff.cuni.cz>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 15 Apr 2011 12:33:12 -0400
X-Google-Sender-Auth: fDrODyun4bvZojtoHmh4EM-HJbk
Message-ID: <BANLkTikaymG-5-YoTnG2SPJCnBtXPpfHBQ@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [linux-pm] freezer: should barriers be smp ?
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 12:29, Pavel Machek wrote:
>> > > I believe the code is correct as is.
>> >
>> > that isnt what the code / documentation says.  unless i'm reading them
>> > wrong, both seem to indicate that the proposed patch is what we
>> > actually want.
>>
>> The existing code is correct but it isn't optimal.
>>
>> wmb() and rmb() are heavy-duty operations, and you don't want to call
>> them when they aren't needed.  That's exactly what smp_wmb() and
>> smp_rmb() are for -- they call wmb() and rmb(), but only in SMP
>> kernels.
>>
>> Unless you need to synchronize with another processor (not necessarily
>> a CPU, it could be something embedded within a device), you should
>> always use smp_wmb() and smp_rmb() rather than wmb() and rmb().
>
> Maybe; but this code is not performance critical and I believe being
> obvious here is better...

isnt it though ?  especially when we talk about suspending/resuming on
embedded systems to get more savings over just cpu idle ?  we want
that latency to be as low as possible.
-mike
