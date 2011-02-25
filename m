Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1BYOTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:19:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38832 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab1BYOTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kzJynKYbgXsPbyw/kBuMLYbxn3Ra/ErsOs5QLAk6ZYsWN8xem0TuUbpTQNtZFjATkB
         cEz1sxnMDHzfM1yGdxQoNm3qyygA2P08W6qX1s8JFBQcSjzSQ5ihxDMPc//3z5XjIM5n
         p2VQzZj9ljgWIXvkPcESIoSkz5Rdiplgtqs70=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com>
References: <20110219150644.681D59D401D@zog.reactivated.net>
	<AANLkTi=29myerzgH6WRCSOPKpaDnGgEtQacVHvxRoQT_@mail.gmail.com>
Date: Fri, 25 Feb 2011 14:19:33 +0000
X-Google-Sender-Auth: JnPfTUfRmdSM4fcgmr4qVxO0Tk0
Message-ID: <AANLkTi=2a=9=k+ZG46yqKOaHd9tCkJVm4QRxGmgbRzsv@mail.gmail.com>
Subject: Re: [PATCH] olpc_battery: bind to device tree
From: Daniel Drake <dsd@laptop.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 February 2011 20:34, Grant Likely <grant.likely@secretlab.ca> wrote:
> As mentioned in the other thread, matching by name is strongly
> discouraged.  It isn't very accurate and compatible is the preferred
> method for binding devices.  'battery' in particular is highly
> non-specific.
>
> I do understand that you don't have a compatible property in the
> current firmware, and to a certain extent we have to live with what
> we're given by the kernel.  However, I think it would be better in the
> OLPC case to find the battery node and add a compatible property
> before registering a platform_device for it.  (or use a bus notifier
> to tell you when it is registered, and add 'compatible' at that
> point.)  That way we the uncertainty is taken care of in the board
> support code without polluting the driver matching namespace.

Thanks for the review. This and the rest of your feedback makes sense.

Would you mind commenting on exactly how this should look?

Here are the changes i'm planning to make, both to the firmware and
with kernel code as you suggest to fixup device trees for systems with
old firmware:

/battery@0/compatible property added with value "olpc-battery" (XO-1 and XO-1.5)
/pci/isa@f/rtc@i70/compatible property prepended with "olpc-xo1-rtc,"
(XO-1 only)
/pci/display@1,1/dcon device added, name=dcon compatible=olpc-dcon
(XO-1 and XO-1.5)

In addition to the battery patch you reviewed, we plan to make the
olpc-rtc and DCON drivers bind to device tree nodes, which is the
reason behind the other changes.

Daniel
