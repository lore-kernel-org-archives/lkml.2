Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2DSR7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:59:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50124 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2DSR7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:59:41 -0400
Message-ID: <4F90527B.7020005@zytor.com>
Date: Thu, 19 Apr 2012 10:59:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
References: <1334794610-5546-1-git-send-email-hpa@zytor.com> <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab> <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com> <20120419173802.GI3221@aftab.osrc.amd.com>
In-Reply-To: <20120419173802.GI3221@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 10:38 AM, Borislav Petkov wrote:
> 
> Yeah, simplicity is the key here. I don't think we're getting that many
> early boot exceptions due to rdmsr or whatever to warrant adding a bunch
> of code.
> 
> OTOH, if we can share early and normal exception handling lookup code, then a
> perfect hash would make sense as those exceptions would pile up.
> 

Obviously we should use the hash after the main kernel is up, too.
Anything else would be silly.

I would argue that the O(1) hash makes things simpler as there is no
need to deal with collisions at all.  The one advantage with "plain"
hashes is that can be runtime modified, which would be of some interest
if we create one single hash table that includes modules.

*That* seems complex to me, though.

	-hpa
