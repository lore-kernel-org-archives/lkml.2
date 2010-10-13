Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0JMIst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:48:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:45546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0JMIsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:48:46 -0400
Subject: Re: [PATCH v2] lockdep: check the depth of subclass
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Dmitry Torokhov <dtor@mail.ru>, Vojtech Pavlik <vojtech@ucw.cz>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1286958626-986-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <4CB56A43.9040706@dcl.info.waseda.ac.jp>
	 <1286958626-986-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Oct 2010 10:48:29 +0200
Message-ID: <1286959709.29097.124.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 17:30 +0900, Hitoshi Mitake wrote:
> Current look_up_lock_class() doesn't check the parameter "subclass".
> This rarely rises problems because the main caller of this function,
> register_lock_class(), checks it.
> But register_lock_class() is not the only function which calls
> look_up_lock_class(). lock_set_class() and its callees also call it.
> And lock_set_class() doesn't check this parameter.
> 
> This will rise problems when the the value of subclass is larger than
> MAX_LOCKDEP_SUBCLASSES. Because the address (used as the key of class)
> caliculated with too large subclass has a possibility to point
> another key in different lock_class_key.
> Of course this problem depends on the memory layout and
> occurs with really low possibility.
> 
> And mousedev_create() calles lockdep_set_subclass() and
> sets class of mousedev->mutex as MOUSEDEV_MIX(== 31).
> And if my understanding is correct,
> this subclass doesn't have to be MOUSEDEV_MIX,
> so I modified this value to SINGLE_DEPTH_NESTING.
> 
> v2: Based on Peter Zijlstra's advice, I removed the
> checking of the subclass value from __lock_acquire().
> Because this is already a redundant thing.
> 
> # If you need devided version for mousedev.c and lockdep.c,
> # feel free to tell me.

I've taken the patch without the mousedev hunk, as Dmitry said he'd take
that.

Thanks!
