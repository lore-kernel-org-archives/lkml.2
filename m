Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1DLF7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:59:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41118 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1DLF65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aAqn9pwh+yls/qbA421Qhy8cgAAvrDzPo0PLj26OrwTmOM08VWBNcsLiQu7CfVm3h8
         2NJnerkDwtqu3i21rNJorhrE/ft9sfgy9djJARBgbyoZ4t+KsFUwiwffojTLAXJcUFqT
         4o6lgBKMnqtdWz2154e2i3BP7R+38SPsWAGeI=
Date: Mon, 11 Apr 2011 22:58:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: Re: undefined reference to `sparse_keymap_free'
Message-ID: <20110412055851.GA1854@core.coreip.homeip.net>
References: <BANLkTinNm_j_SpjTXKVPXkWFmyjBZAQWyQ@mail.gmail.com>
 <20110411224819.b349025a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411224819.b349025a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 10:48:19PM -0700, Andrew Morton wrote:
> (cc's added)
> 
> On Mon, 11 Apr 2011 23:18:04 -0500 Steve French <smfrench@gmail.com> wrote:
> 
> > 2.6.38-rc3 build error:
> > 
> > drivers/built-in.o: In function `msi_laptop_input_destroy':
> > msi-laptop.c:(.text+0x1a3be1): undefined reference to `sparse_keymap_free'
> > drivers/built-in.o: In function `msi_send_touchpad_key':
> > msi-laptop.c:(.text+0x1a3c45): undefined reference to
> > `sparse_keymap_report_event'
> > drivers/built-in.o: In function `msi_init':
> > msi-laptop.c:(.init.text+0xe055): undefined reference to `sparse_keymap_setup'
> > msi-laptop.c:(.init.text+0xe07d): undefined reference to `sparse_keymap_free'
> > 
> 
> Either a missing CONFIG_INPUT_SPARSEKMAP dependency, or missing stubs in
> include/linux/input/sparse-keymap.h?
> 

No, stubs for sparse keymap do not make sense (either one wants to use
this library-like module or she does not), so it must be the missing
"select" (sparse keymap should be selectable as long as selecting module
depends on CONFIG_INPUT).

Thanks.

-- 
Dmitry
