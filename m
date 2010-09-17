Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0IQVxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 17:53:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:45448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0IQVxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 17:53:01 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 1/4] Dynamic Debug: Introduce global fake module param module.ddebug - V3
Date: Fri, 17 Sep 2010 23:52:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1.99.9.f8e4270-desktop; KDE/4.4.4; x86_64; ; )
Cc: bjorn.helgaas@hp.com, gregkh@suse.de, linux-kernel@vger.kernel.org
References: <1284588708-54170-1-git-send-email-trenn@suse.de> <1284588708-54170-2-git-send-email-trenn@suse.de> <20100917195456.GA2825@redhat.com>
In-Reply-To: <20100917195456.GA2825@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009172352.46631.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> So i'm wondering if need to support the module.ddebug on the command
> line?
Yep, that would make things a bit easier...
People would e.g. have to use ddebug_query="module pnp +p"  (which 
already is available with the patch that is queued in linux-next)
instead of pnp.ddebug. Not that obvious or say user friendly, though.

> The ddebug_query="module foo +p" format that you introduced does
> the same thing. 
No that does not work for real (not built-in) modules. Give it a try...
The stuff needs to be set up when the module is loaded.
If you have a real module declared as =m
You need to call "module foo +p" when the module gets/got loaded.
But ddebug_query="..." only gets executed once, when
dynamic debug gets set up, far before any module got loaded.
 
> Also, we can't put those large char[] arrays on the kernel stack. They
> probably should be global.
Where exactly, the command line(*args)?

    Thomas
