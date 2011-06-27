Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1F0PIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 11:08:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47487 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1F0PIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 11:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tw3D5Drx/kz9nkbNOm/ny4rAP4MMuFYOAiL/zipDaXzXhMxPHpSaFL/Xi2DczH+CDG
         irKIfwBESNzbgpoiyZpIZpq4OUOIdz6ZZU4drlpKnyqk89C1ZKqKiMnJMOlz8xW4VQbZ
         qwTcVyFcmkAeL12lyisQNgzNpBVFOZYZWIvSw=
Subject: Re: random(4) driver questions
From: Sasha Levin <levinsasha928@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Sandy Harris <sandyinchina@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110627145442.GA2729@thunk.org>
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
	 <20110627145442.GA2729@thunk.org>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 27 Jun 2011 11:08:13 -0400
Message-ID: <1309187293.15376.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 10:54 -0400, Ted Ts'o wrote:
> > What happens to /dev/random when it runs on
> > a virtual machine and all the things it relies on
> > for entropy get virtualised away?
> > 
> > The server that the VM is hosted on will usually
> > have plenty of entropy, often a hardware RNG.
> > Is there an interface that makes that visible
> > from the VM? Perhaps a virtual "hardware"
> > RNG driven by /dev/urandom on the host?
> 
> Yes, paravirtualizing the random number generator would be a big help.
> Probably what I would do is to periodically add entropy from the host
> OS to the guest OS, via some paravirt channel.  This would add a new
> "catastrophic reseeding", and if the virtual guest can mix in some
> other unknown material, again that can only help.

virtio has a 'virtio-rng' device which does just that.

-- 

Sasha.

