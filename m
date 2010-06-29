Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0F2LZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:25:38 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:52912 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0F2LZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:25:36 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=TiHLsqXsd+6ryaOnj0cNviK18ZwyVycWxPb6i7kmmShhpZZZeLtIN61JDOaSlBn/wmatv1oiyZTHrR2ABNXqquaTpm3291Cd1RX/2VQfMskJ0XsBlCQNZMA6JjSgr8wwBZZvVUa817p89yb9oVNEtStf+bCRZ2leDIM4zQ98SwY=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] dynamic_debug: allow to set dynamic debug flags right at module load time
User-Agent: KMail/1.13.5 (Linux/2.6.31.12-0.2-default; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201005261425.39058.roman.fietze@telemotive.de> <201005270705.44179.roman.fietze@telemotive.de> <20100528135549.GA2528@redhat.com>
In-Reply-To: <20100528135549.GA2528@redhat.com>
MIME-Version: 1.0
Message-ID: <201006291325.29983.roman.fietze@telemotive.de>
Date: Tue, 29 Jun 2010 13:25:29 +0200
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 29.06.2010 13:25:30,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 29.06.2010 13:25:30,
	Serialize complete at 29.06.2010 13:25:30
Content-Transfer-Encoding: 7bit
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason, hello LKML,

On Friday 28 May 2010 15:55:49 Jason Baron wrote:

> right, i think we want to add something inside ddebug_add_module()
> that recognizes if the module was loaded with verbose=1. I think you
> can get at the parameters via module->kp, which we need to pass in
> as well.

Yes, I would first check if there's a section named "__verbose" as it
is right now. If yes, I would search the already setup module->kp for
the used parameter.


Proposals, not being sure how to implement that right now:

Default is to search e.g. for param "dprintk".

Provide a macro to override that default, e.g.
DPRINTK_PARAM("verbose")

If the default or defined bool or other integer parameter is unequal
to 0 enable the p-flag on module load for all debug statements of this
module.


Questions just in case the proposal is kind of ok:

Prepare the code to allow the setting of different future flags
unequal to 'p'?

Use a charp param instead of a bool to allow that?


Roman

-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
