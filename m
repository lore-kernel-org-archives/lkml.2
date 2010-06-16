Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab0FPJpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:45:24 -0400
Received: from poutre.nerim.net ([62.4.16.124]:56230 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0FPJpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:45:20 -0400
Date: Wed, 16 Jun 2010 11:45:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: David Daney <david.s.daney@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8]i2c:i2c_core Fix warning: variable 'dummy' set but 
  not used
Message-ID: <20100616114517.5ac49e26@hyperion.delvare>
In-Reply-To: <4C17A857.8030306@caviumnetworks.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
	<1276547208-26569-7-git-send-email-justinmattock@gmail.com>
	<20100614225315.2bae9e37@hyperion.delvare>
	<4C169F19.1040608@gmail.com>
	<20100615134039.6ccfc17a@hyperion.delvare>
	<4C17A857.8030306@caviumnetworks.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 09:20:39 -0700, David Daney wrote:
> On 06/15/2010 04:40 AM, Jean Delvare wrote:
> > __process_new_adapter() calls i2c_do_add_adapter() which always returns
> > 0. Why should I check the return value of bus_for_each_drv() when I
> > know it will always be 0 by construction?
> >
> > Also note that the same function is also called through
> > bus_for_each_dev() somewhere else in i2c-core, and there is no warning
> > there because bus_for_each_dev() is not marked __must_check. How
> > consistent is this? If bus_for_each_dev() is OK without __must_check,
> > then I can't see why bus_for_each_drv() wouldn't be.
> 
> Well, I would advocate removing the __must_check then.

I have just sent a patch to LKML doing exactly this.

-- 
Jean Delvare
