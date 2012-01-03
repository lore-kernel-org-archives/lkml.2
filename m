Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab2ACXLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:11:40 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42989 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2ACXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:11:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steve Grubb <sgrubb@redhat.com>
Cc: Colin Walters <walters@verbum.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        LKML <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        morgan@kernel.org, luto@mit.edu, kzak@redhat.com
Subject: Re: chroot(2) and bind mounts as non-root
References: <1323280461.10724.13.camel@lenny>
	<1323982580.31563.15.camel@lenny> <m1k45xyreb.fsf@fess.ebiederm.org>
	<201112211315.44175.sgrubb@redhat.com>
Date: Tue, 03 Jan 2012 15:13:40 -0800
In-Reply-To: <201112211315.44175.sgrubb@redhat.com> (Steve Grubb's message of
	"Wed, 21 Dec 2011 13:15:43 -0500")
Message-ID: <m11urgidln.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Yaj84/J0eumLJJugRxAyUTlkwcmQtUQY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Grubb <sgrubb@redhat.com> writes:

> On Friday, December 16, 2011 01:14:36 AM Eric W. Biederman wrote:
>> Since except at the edges of userspace we use uids and gids in the
>> initial user namespace, the implications for confusing other security
>> mechanisms is minimized.
>
> Is anyone thinking about how this affects the audit system?

A little.

Today the audit system can only be used from the initial namespaces and
the pids that we use are from the initial pid namespace.

It is my expectation that we can continue the same pattern for uids as
well.

Eric
