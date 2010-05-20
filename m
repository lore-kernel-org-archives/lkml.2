Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0ETQpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:45:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56434 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0ETQpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=OU8WtKzgPV7YLS7mO0DlQMfy3DbiMQmC8kvieCkBvLR4VStGAnJV3pVPjHTbc/cqJV
         nGufJgnhhsSN60+oZmw++15lOaL4q4cg1x31RdYZazFpjDtdoHGIbgm2edG3+96SyaXO
         DRXw3bmll8uq69RvQE1CYJCD8FG+VkYBqSEv4=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2010-05-19 BUG weirdness...
Date: Thu, 20 May 2010 09:45:24 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.34; KDE/4.4.2; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org> <4637.1274370470@localhost> <20100520085520.5176d13c.akpm@linux-foundation.org>
In-Reply-To: <20100520085520.5176d13c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005200945.24901.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 May 2010 05:55:20 am Andrew Morton wrote:
> On Thu, 20 May 2010 11:47:50 -0400 Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 19 May 2010 16:13:09 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-05-19-16-12 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > So I'm looking closer at the BUG I just posted
> 
> I can't see that BUG report on lkml or in inbox.
> 
> > - I had deleted two further
> > BUGs because they were obviously follow-ons to the original.  But then...
> > 
> > Note the following 2 lines:
> > 
> > [   35.357018] note: keymap[2481] exited with preempt_count 1
> > [   35.360503] BUG: scheduling while atomic: keymap/2481/0x10000002
> > 
> > The kernel reports the instigating process exited - and then reports it
> > as the offender for a "scheduling while atomic". Insufficient attempted
> > cleanup after the first BUG?  Do we care because this is a sign of a
> > scheduler bug that could trip on a non-BUG as well, or is it "all bets
> > are off" because of the first BUG?
> 
> Yes, the oops code will end up calling do_exit() to get rid of this
> process and to try to keep the machine limping along.  So if you hit an
> oops with (say) a spinlock held, the task will end up calling do_exit()
> with a non-zero preempt_count.
> 
> So the only problem I'm seeing here is .... Dmitry's ;)


Hmm, any chance you could stick a printk in input_set_keycode and print
the id/name of the input device?

-- 
Dmitry
