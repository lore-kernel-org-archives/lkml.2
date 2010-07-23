Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0GWJxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 05:53:33 -0400
Received: from n5.bullet.mail.gq1.yahoo.com ([67.195.9.85]:40863 "HELO
	n5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753435Ab0GWJxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 05:53:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 290684.40679.bm@omp126.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=ntxB4ZUi0lU2NLgSo80/D3XU98L4hBZVjYxqot91qUPSJ5DmIh/IrMixlCHi5uy19iR6EnN+Rlbo9MSV68H9KUdUJ0FPcO6V97P+2auQ3TkGDn1dMfQXLxVmHmHsIXvx8PcIqnZwJfz67RX50gJVasUbbfB4DhnMQTUELMUD4t0=;
Message-ID: <94320.67137.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: 9riY6EMVM1mHOQOyVzglVd_aDo_O8446.OdrYYj7nYcYHcV
 8tpLb_PX74kWoMO69wz5rMrZZwDVgbVEMAfK8BRAnWyzGJ2Bxn1ynW0NvbEe
 MFbTgMDGJwpH7M1FwXc7Plv6HNWh.k3cLOcAubQBHfNk92TsHoPiwjUhAEFn
 DYiciKph6kzrN4y8pgdRw25Bja4I2KVtQTRxRaMnH28ExatYv0sUG6QMzWN2
 jAqSKKj.vqnzowB6atdPj3JZInYJ9h6nPEqOPNbQbQ2hnIrdxJRHdIs2RR3s
 Aqjt8GdSLPQjlJcrjrz5oknd3pv294Ej63GXz4TacEWwRavFcC4oHxA--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Fri, 23 Jul 2010 02:53:30 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] musb: move usb_add_hcd to the core init code from gadget code
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
        Bryan Wu <bryan.wu@canonical.com>
Cc: kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        ricardo.salveti@canonical.com
In-Reply-To: <1279877769-5210-1-git-send-email-bryan.wu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you sure this doesn't break the hardware
initialization sequencing on some chips?

I distinctly call losing over a month of development
time on this issue, because the hardware has some
undocumented constraints in this area.  The entire
reeason the host init is so "late" is that doing
it earlier (at more logically sensible moments, (in
terms of USB specs vs Mentor silicon) broke things.

- Dave


