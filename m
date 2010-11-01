Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0KAPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:39:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44338 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab0KAPjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qK34fhUud4qx6CjOy3t+SIx7a6hVmBInS6/TMiPiAszLZYIT7/YZx3xk0skROzwPYn
         AJqjyFoV8AbnrWHdYYf7v1f5b5zHhKSnjjqdkNSynKV1mitBb9Ewmrt9lNcnFsWc/dbt
         k8P4DTY6f2uVC0JyVAgiGw68uuOAeKOAgdO1w=
MIME-Version: 1.0
In-Reply-To: <20101102023650.bc553e74.sfr@canb.auug.org.au>
References: <6631e123845856ac20423c25e07844c8@mail.gmail.com>
	<AANLkTikWWGpAM8+_z9fnngYuYSpT3NWgM7xeGkOzZ3jg@mail.gmail.com>
	<AANLkTikQuUcAMZKqZ3Rz5HVzOs+63-Y4VYUo5-3EM30H@mail.gmail.com>
	<20101102023650.bc553e74.sfr@canb.auug.org.au>
Date: Mon, 1 Nov 2010 11:39:47 -0400
Message-ID: <AANLkTin3nsb6FfNtXfqjZCuV66mwKVOsKgmZpTABFDUJ@mail.gmail.com>
Subject: Re: All Applied micro boards are failing with current mainline kernel
From: Josh Boyer <jwboyer@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rupjyoti Sarmah <rsarmah@apm.com>, Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 11:36 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Josh,
>
> On Mon, 1 Nov 2010 11:05:53 -0400 Josh Boyer <jwboyer@gmail.com> wrote:
>>
>> A few hints would be appreciated.
>
> Remove the call to netif_stop_queue() from emac_probe().  Apparently,
> calling this before register_netdev() is now wrong (maybe always was).

Yeah, I just discovered that myself.  I'm wondering

1) why we do that in that function?
2) If it needs to be removed entirely, or moved to after the
register_netdev call
3) If the call to netif_carrier_off also needs similar attention.

I can whip up a patch to remove those calls or move them after the
register, but I don't want to do that without knowing which one is
"right".

josh
