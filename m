Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0DLH3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 03:29:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:19953 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0DLH3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 03:29:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=ZCeRkE0cF6a21U+C2rzK5MHcCG/8k75/eDvLm/gCkepeeA1TGyzNClHA8wcLR1kMfC
         q+j/6nmSCpcKH0hWb8nYMnwwcMvkwsoMlP6FYkOiu6VO12Jd0Y2q+iQBIJz6KC7XfCgb
         7y8uQxck9I9mwOZFNWwKiQiCdmfPH0XpHBJYc=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 12 Apr 2010 15:29:16 +0800
Message-ID: <q2t427d64721004120029n91bb5bcg1416b34dda1a28be@mail.gmail.com>
Subject: [PATCH] max732x: Correct nr_port checking off by one error
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Eric Miao <eric.miao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup both client_group_a and client_group_b if nr_port > 8 (not
including nr_port==8).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/max732x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/max732x.c b/drivers/gpio/max732x.c
index f786824..51b02c6 100644
--- a/drivers/gpio/max732x.c
+++ b/drivers/gpio/max732x.c
@@ -285,14 +285,14 @@ static int __devinit max732x_probe(struct
i2c_client *client,
        switch (client->addr & 0x70) {
        case 0x60:
                chip->client_group_a = client;
-               if (nr_port > 7) {
+               if (nr_port > 8) {
                        c = i2c_new_dummy(client->adapter, addr_b);
                        chip->client_group_b = chip->client_dummy = c;
                }
                break;
        case 0x50:
                chip->client_group_b = client;
-               if (nr_port > 7) {
+               if (nr_port > 8) {
                        c = i2c_new_dummy(client->adapter, addr_a);
                        chip->client_group_a = chip->client_dummy = c;
                }
@@ -307,7 +307,7 @@ static int __devinit max732x_probe(struct
i2c_client *client,
        mutex_init(&chip->lock);

        max732x_read(chip, is_group_a(chip, 0), &chip->reg_out[0]);
-       if (nr_port > 7)
+       if (nr_port > 8)
                max732x_read(chip, is_group_a(chip, 8), &chip->reg_out[1]);

        ret = gpiochip_add(&chip->gpio_chip);
-- 
1.5.4.3
