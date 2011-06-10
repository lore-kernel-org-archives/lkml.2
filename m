Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab1FJUko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:40:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33452 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJUkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:40:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MBUJtSfQFaX6BknhOEt9+baDtZJatXfitCZlow+fWulosE4xGE+qxmos8o3mqL4LC4
         uPKGv9vLHv2LS/CyVkWW1EvOEc4TBx4LUTgX/EBMqaePWIrnn8My0LBEEKl7I8AllKKW
         iT14AGcV6o0vqiPSU+XiWdAaXkbh9Zb3jHNis=
Subject: Re: [PATCH 1/3] posix-timers: remove idr_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
References: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 22:40:38 +0200
Message-ID: <1307738438.2872.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 10 juin 2011 à 13:13 -0700, Andi Kleen a écrit :
> From: Andi Kleen <ak@linux.intel.com>
> 
> idr_lock is only used to protect the global posix_timers idr,
> but idr does its own locking (or RCUing) anyways and doesn't
> need it. So remove it.

Are you sure of this assertion Andi ?

I believe we need an external synchronization before calling
idr_remove() / idr_get_new()



