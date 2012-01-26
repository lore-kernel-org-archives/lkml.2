Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2AZXyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:54:46 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:36778 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2AZXyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:54:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, xemul@parallels.com,
        sjur.brandeland@stericsson.com, levinsasha928@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        sjurbren@gmail.com
Subject: Re: [PATCH] netns: fix net_alloc_generic()
References: <4F212E7E.2040801@parallels.com>
	<1327575108.2500.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<m1zkdacbsx.fsf@fess.ebiederm.org>
	<20120126.180754.679593869814492219.davem@davemloft.net>
Date: Thu, 26 Jan 2012 15:57:18 -0800
In-Reply-To: <20120126.180754.679593869814492219.davem@davemloft.net> (David
	Miller's message of "Thu, 26 Jan 2012 18:07:54 -0500 (EST)")
Message-ID: <m1liouc90h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18tszV6W07R1k6MeXmYFwemYrJUfAh4tC0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Thu, 26 Jan 2012 14:57:02 -0800
>
>> It is not a chicken and egg problem.  It is a bug in caif.
>> caif is claiming to be a network device when it is acting as a subsytem.
>> That means it is being initialized too late.
>> 
>> Untested but this should trivially fix the problem, and a bunch
>> of others of the same ilk.
>> 
>> It is not safe to shutdown subsystems until all of the devices
>> are gone, otherwise there will be problems with packets in flight.
>
> If you guys can agree that this is the better fix, and we can
> get testing showing that it works, I'll revert Eric D.'s patch
> and apply the final version of this one.

Eric D.'s change is correct, but it is just an optimization of
net_assign_generic.  Eric D.'s change is not a bug fix.

Tested fix in a moment.

Eric
