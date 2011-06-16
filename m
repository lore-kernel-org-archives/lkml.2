Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1FPLTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:19:41 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:60130 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1FPLTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:19:40 -0400
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
 Vpid:)
From: Greg Kurz <gkurz@fr.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr,
        ebiederm@xmission.com, xemul@openvz.org
In-Reply-To: <20110615190302.GA16440@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local>
	 <20110615190302.GA16440@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 13:19:18 +0200
Message-ID: <1308223158.8230.66.camel@bahia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-15 at 21:03 +0200, Oleg Nesterov wrote:
> Forgot to ask,
> 
> On 06/15, Greg Kurz wrote:
> >
> > The need arises in the LXC community when one wants to send a signal from
> > the host (aka. init_pid_ns context) to a container process for which one
> > only knows the pid inside the container.
> 
> I am just curious, why do you need this?
> 

Because some LXC users run partially isolated containers (AKA.
application containers started with the lxc-execute command). Some of
the user code runs outside the container and some inside. Since
lxc-execute uses CLONE_NEWPID, it's difficult for the external code to
relate a pid generated inside the container with a task. There are
regular requests on lxc-users@ about this.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

