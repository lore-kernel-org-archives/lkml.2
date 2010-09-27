Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab0I0JSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758951Ab0I0JSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:18:07 -0400
Message-ID: <4CA06147.7080805@redhat.com>
Date: Mon, 27 Sep 2010 11:17:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <4CA057EA.7000609@redhat.com> <768A5DC0-131A-4BC8-ADDD-044D8169545E@suse.de> <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de>
In-Reply-To: <61284934-1AD3-4F7A-9488-D46FCEE9B753@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/27/2010 11:15 AM, Alexander Graf wrote:
> >
> >  Wow, this is incredibly ugly :). Can't we just mask NMIs when the interrupt shadow is active?

I plan to do that, for all the code that's out there relying on on STI 
interrupt shadow masking NMIs.

> Yeah, that's me writing without thinking. So this means that the race can also happen on real hardware?
>

Yes.  At least on documented hardware.  Some (most? all?) hardware does 
mask NMIs after STI.

-- 
error compiling committee.c: too many arguments to function

