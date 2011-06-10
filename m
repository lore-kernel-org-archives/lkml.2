Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab1FJSIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:08:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61849 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab1FJSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kJ7PxpiqraehsjDBgUOU5WGYgfNkAXS0LgGXznpjmmPM6HD9H8cY6SYFLcgz+tDo8+
         95rMMz8g9tqTICLYEdSk8jIjgRNqq+qKmtkwTJ1jJ44xOEAssFDALB8RTYxKjXE4K7Xy
         GhdGC3/bUSJlx/fyk08e4q3pVR5cp0McZKRuI=
MIME-Version: 1.0
In-Reply-To: <4DF1D08B.100@jp.fujitsu.com>
References: <4df13b81272475cf94@agluck-desktop.sc.intel.com>
	<4DF1D08B.100@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 11:08:41 -0700
X-Google-Sender-Auth: Wqke1W_XHD8p-eEWwHnHLqvUejA
Message-ID: <BANLkTinGZt1=uWrTDaEuT+DM1X3h+u1mng@mail.gmail.com>
Subject: Re: [PATCH 02/10] MCE: save most severe error information
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
> Could you clarify why we have to use mces_seen after mce_end(), please?

In part 10 I add:
+       if (worst == MCE_AR_SEVERITY) {
+               mce_action_required(&m, msg, regs);
+               kill_it = 0;
+       }

Which happens after mce_end() ... and wants to access the struct mce that
we filled out for this processor.

But it is possible that we don't need it - your comments to later parts
of this patch series point out that better severity table entries could
cover the checks for ADDRV and MISCV being set, and make the
error immediately fatal, rather than leaving it until this late stage to
do so.

I think we only actually need to save the address from the mce structure.

-Tony
