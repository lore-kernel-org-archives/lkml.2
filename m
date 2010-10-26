Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab0JZIOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab0JZIOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:14:32 -0400
Message-ID: <4CC68DE1.1060604@redhat.com>
Date: Tue, 26 Oct 2010 10:14:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4CC6130B.8020908@goop.org>
In-Reply-To: <4CC6130B.8020908@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/26/2010 01:30 AM, Jeremy Fitzhardinge wrote:
> Unfortunately this is breaking Xen save/restore: if you restore on a
> host which was booted more recently than the save host, causing the
> system time to be smaller.  The effect is that the domain's time leaps
> forward to a fixed point, and stays there until the host catches up to
> the source host...

Shouldn't save/restore also save the timebase?

> I guess last_time needs to be reset on this type of event.  I guess the
> cleanest way would be for pvclock.c to register a sysdev suspend/resume
> handler.

Should be for Xen only; kvm save/restore doesn't involve the guest.

-- 
error compiling committee.c: too many arguments to function

