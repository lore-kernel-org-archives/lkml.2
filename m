Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0HIGk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:40:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34407 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab0HIGk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VkDokw7EWFOjp0PLyICBKutIDEaT6m2haGeNEldvmKpHdamOnNYf0D7PqEoyuBhuT3
         X20nq5QhTqeYNOZbpzjf114hCrKptnns8I5QTzB8wd43T4rlxgOm2+1eLWhTW3++Nc4L
         752UZ8mANAmVzLOFcb9BZQXgrrcUAl27wuEA8=
Subject: Re: [PATCH] x86: remove __phys_reloc_hide
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87k4o08fv9.fsf@basil.nowhere.org>
References: <1281303490-390-1-git-send-email-namhyung@gmail.com>
	 <87k4o08fv9.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 15:40:31 +0900
Message-ID: <1281336031.976.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-09 (월), 08:22 +0200, Andi Kleen:

> It's for the benefit of the compiler, we've had miscompilations
> due to undefined overflow for addresses in the past. The optimizer
> assumes this won't happen.
> 
> Given the x86-64 version normally doesn't overflow, but it's
> still safer to have it.
> 
> -Andi
> 

Hi, 

I'm not talking about the RELOC_HIDE itself. I do know we need it for
some specific case, ie. percpu. But in this case __pa_symbol(x) is
expanded to RELOC_HIDE((unsigned long)(x), 0) which does nothing
meaningful. I believe the overflow is not a concern here.

-- 
Regards,
Namhyung Kim


