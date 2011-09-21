Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1IUTeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:34:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35220 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1IUTdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:33:53 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] arm/tegra: Move "gpio-names.h" into <mach/gpio-tegra.h>
Date: Wed, 21 Sep 2011 13:33:40 -0600
Message-Id: <1316633620-13184-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This centralizes all SoC-level GPIO-related definitions into a single
header file.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mach-tegra/board-harmony-pinmux.c    |    1 -
 arch/arm/mach-tegra/board-harmony.c           |    1 -
 arch/arm/mach-tegra/board-paz00-pinmux.c      |    1 -
 arch/arm/mach-tegra/board-paz00.c             |    1 -
 arch/arm/mach-tegra/board-seaboard-pinmux.c   |    1 -
 arch/arm/mach-tegra/board-seaboard.c          |    1 -
 arch/arm/mach-tegra/board-trimslice-pinmux.c  |    1 -
 arch/arm/mach-tegra/board-trimslice.c         |    2 -
 arch/arm/mach-tegra/devices.c                 |    2 +-
 arch/arm/mach-tegra/gpio-names.h              |  247 -------------------------
 arch/arm/mach-tegra/include/mach/gpio-tegra.h |  225 ++++++++++++++++++++++
 11 files changed, 226 insertions(+), 257 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/gpio-names.h

diff --git a/arch/arm/mach-tegra/board-harmony-pinmux.c b/arch/arm/mach-tegra/board-harmony-pinmux.c
index 4d63e2e..4191a9f 100644
--- a/arch/arm/mach-tegra/board-harmony-pinmux.c
+++ b/arch/arm/mach-tegra/board-harmony-pinmux.c
@@ -18,7 +18,6 @@
 #include <linux/gpio.h>
 #include <mach/pinmux.h>
 
-#include "gpio-names.h"
 #include "board-harmony.h"
 
 static struct tegra_pingroup_config harmony_pinmux[] = {
diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index 5835225..1e6a20f 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -42,7 +42,6 @@
 #include "board-harmony.h"
 #include "clock.h"
 #include "devices.h"
-#include "gpio-names.h"
 
 static struct plat_serial8250_port debug_uart_platform_data[] = {
 	{
diff --git a/arch/arm/mach-tegra/board-paz00-pinmux.c b/arch/arm/mach-tegra/board-paz00-pinmux.c
index 2225769..39a4858 100644
--- a/arch/arm/mach-tegra/board-paz00-pinmux.c
+++ b/arch/arm/mach-tegra/board-paz00-pinmux.c
@@ -18,7 +18,6 @@
 #include <linux/gpio.h>
 #include <mach/pinmux.h>
 
-#include "gpio-names.h"
 #include "board-paz00.h"
 
 static struct tegra_pingroup_config paz00_pinmux[] = {
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index c888b0e..ae94f79 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -42,7 +42,6 @@
 #include "board-paz00.h"
 #include "clock.h"
 #include "devices.h"
-#include "gpio-names.h"
 
 static struct plat_serial8250_port debug_uart_platform_data[] = {
 	{
diff --git a/arch/arm/mach-tegra/board-seaboard-pinmux.c b/arch/arm/mach-tegra/board-seaboard-pinmux.c
index 74f78b7..fbfeb9c 100644
--- a/arch/arm/mach-tegra/board-seaboard-pinmux.c
+++ b/arch/arm/mach-tegra/board-seaboard-pinmux.c
@@ -19,7 +19,6 @@
 #include <mach/pinmux.h>
 #include <mach/pinmux-t2.h>
 
-#include "gpio-names.h"
 #include "board-seaboard.h"
 
 #define DEFAULT_DRIVE(_name)					\
diff --git a/arch/arm/mach-tegra/board-seaboard.c b/arch/arm/mach-tegra/board-seaboard.c
index bf13ea3..53e6ce6 100644
--- a/arch/arm/mach-tegra/board-seaboard.c
+++ b/arch/arm/mach-tegra/board-seaboard.c
@@ -39,7 +39,6 @@
 #include "board-seaboard.h"
 #include "clock.h"
 #include "devices.h"
-#include "gpio-names.h"
 
 static struct plat_serial8250_port debug_uart_platform_data[] = {
 	{
diff --git a/arch/arm/mach-tegra/board-trimslice-pinmux.c b/arch/arm/mach-tegra/board-trimslice-pinmux.c
index bcb1916..b358aac 100644
--- a/arch/arm/mach-tegra/board-trimslice-pinmux.c
+++ b/arch/arm/mach-tegra/board-trimslice-pinmux.c
@@ -19,7 +19,6 @@
 
 #include <mach/pinmux.h>
 
-#include "gpio-names.h"
 #include "board-trimslice.h"
 
 static __initdata struct tegra_pingroup_config trimslice_pinmux[] = {
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index e3ff88b..b0f77ea 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -37,8 +37,6 @@
 #include "board.h"
 #include "clock.h"
 #include "devices.h"
-#include "gpio-names.h"
-
 #include "board-trimslice.h"
 
 static struct plat_serial8250_port debug_uart_platform_data[] = {
diff --git a/arch/arm/mach-tegra/devices.c b/arch/arm/mach-tegra/devices.c
index 57e35d2..a5ea0ac 100644
--- a/arch/arm/mach-tegra/devices.c
+++ b/arch/arm/mach-tegra/devices.c
@@ -25,11 +25,11 @@
 #include <linux/i2c-tegra.h>
 #include <linux/platform_data/tegra_usb.h>
 #include <asm/pmu.h>
+#include <mach/gpio-tegra.h>
 #include <mach/irqs.h>
 #include <mach/iomap.h>
 #include <mach/dma.h>
 #include <mach/usb_phy.h>
-#include "gpio-names.h"
 
 static struct resource i2c_resource1[] = {
 	[0] = {
diff --git a/arch/arm/mach-tegra/gpio-names.h b/arch/arm/mach-tegra/gpio-names.h
deleted file mode 100644
index f28220a..0000000
--- a/arch/arm/mach-tegra/gpio-names.h
+++ /dev/null
@@ -1,247 +0,0 @@
-/*
- * arch/arm/mach-tegra/include/mach/gpio-names.h
- *
- * Copyright (c) 2010 Google, Inc
- *
- * Author:
- *	Erik Gilling <konkers@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef __MACH_TEGRA_GPIO_NAMES_H
-#define __MACH_TEGRA_GPIO_NAMES_H
-
-#define TEGRA_GPIO_PA0		0
-#define TEGRA_GPIO_PA1		1
-#define TEGRA_GPIO_PA2		2
-#define TEGRA_GPIO_PA3		3
-#define TEGRA_GPIO_PA4		4
-#define TEGRA_GPIO_PA5		5
-#define TEGRA_GPIO_PA6		6
-#define TEGRA_GPIO_PA7		7
-#define TEGRA_GPIO_PB0		8
-#define TEGRA_GPIO_PB1		9
-#define TEGRA_GPIO_PB2		10
-#define TEGRA_GPIO_PB3		11
-#define TEGRA_GPIO_PB4		12
-#define TEGRA_GPIO_PB5		13
-#define TEGRA_GPIO_PB6		14
-#define TEGRA_GPIO_PB7		15
-#define TEGRA_GPIO_PC0		16
-#define TEGRA_GPIO_PC1		17
-#define TEGRA_GPIO_PC2		18
-#define TEGRA_GPIO_PC3		19
-#define TEGRA_GPIO_PC4		20
-#define TEGRA_GPIO_PC5		21
-#define TEGRA_GPIO_PC6		22
-#define TEGRA_GPIO_PC7		23
-#define TEGRA_GPIO_PD0		24
-#define TEGRA_GPIO_PD1		25
-#define TEGRA_GPIO_PD2		26
-#define TEGRA_GPIO_PD3		27
-#define TEGRA_GPIO_PD4		28
-#define TEGRA_GPIO_PD5		29
-#define TEGRA_GPIO_PD6		30
-#define TEGRA_GPIO_PD7		31
-#define TEGRA_GPIO_PE0		32
-#define TEGRA_GPIO_PE1		33
-#define TEGRA_GPIO_PE2		34
-#define TEGRA_GPIO_PE3		35
-#define TEGRA_GPIO_PE4		36
-#define TEGRA_GPIO_PE5		37
-#define TEGRA_GPIO_PE6		38
-#define TEGRA_GPIO_PE7		39
-#define TEGRA_GPIO_PF0		40
-#define TEGRA_GPIO_PF1		41
-#define TEGRA_GPIO_PF2		42
-#define TEGRA_GPIO_PF3		43
-#define TEGRA_GPIO_PF4		44
-#define TEGRA_GPIO_PF5		45
-#define TEGRA_GPIO_PF6		46
-#define TEGRA_GPIO_PF7		47
-#define TEGRA_GPIO_PG0		48
-#define TEGRA_GPIO_PG1		49
-#define TEGRA_GPIO_PG2		50
-#define TEGRA_GPIO_PG3		51
-#define TEGRA_GPIO_PG4		52
-#define TEGRA_GPIO_PG5		53
-#define TEGRA_GPIO_PG6		54
-#define TEGRA_GPIO_PG7		55
-#define TEGRA_GPIO_PH0		56
-#define TEGRA_GPIO_PH1		57
-#define TEGRA_GPIO_PH2		58
-#define TEGRA_GPIO_PH3		59
-#define TEGRA_GPIO_PH4		60
-#define TEGRA_GPIO_PH5		61
-#define TEGRA_GPIO_PH6		62
-#define TEGRA_GPIO_PH7		63
-#define TEGRA_GPIO_PI0		64
-#define TEGRA_GPIO_PI1		65
-#define TEGRA_GPIO_PI2		66
-#define TEGRA_GPIO_PI3		67
-#define TEGRA_GPIO_PI4		68
-#define TEGRA_GPIO_PI5		69
-#define TEGRA_GPIO_PI6		70
-#define TEGRA_GPIO_PI7		71
-#define TEGRA_GPIO_PJ0		72
-#define TEGRA_GPIO_PJ1		73
-#define TEGRA_GPIO_PJ2		74
-#define TEGRA_GPIO_PJ3		75
-#define TEGRA_GPIO_PJ4		76
-#define TEGRA_GPIO_PJ5		77
-#define TEGRA_GPIO_PJ6		78
-#define TEGRA_GPIO_PJ7		79
-#define TEGRA_GPIO_PK0		80
-#define TEGRA_GPIO_PK1		81
-#define TEGRA_GPIO_PK2		82
-#define TEGRA_GPIO_PK3		83
-#define TEGRA_GPIO_PK4		84
-#define TEGRA_GPIO_PK5		85
-#define TEGRA_GPIO_PK6		86
-#define TEGRA_GPIO_PK7		87
-#define TEGRA_GPIO_PL0		88
-#define TEGRA_GPIO_PL1		89
-#define TEGRA_GPIO_PL2		90
-#define TEGRA_GPIO_PL3		91
-#define TEGRA_GPIO_PL4		92
-#define TEGRA_GPIO_PL5		93
-#define TEGRA_GPIO_PL6		94
-#define TEGRA_GPIO_PL7		95
-#define TEGRA_GPIO_PM0		96
-#define TEGRA_GPIO_PM1		97
-#define TEGRA_GPIO_PM2		98
-#define TEGRA_GPIO_PM3		99
-#define TEGRA_GPIO_PM4		100
-#define TEGRA_GPIO_PM5		101
-#define TEGRA_GPIO_PM6		102
-#define TEGRA_GPIO_PM7		103
-#define TEGRA_GPIO_PN0		104
-#define TEGRA_GPIO_PN1		105
-#define TEGRA_GPIO_PN2		106
-#define TEGRA_GPIO_PN3		107
-#define TEGRA_GPIO_PN4		108
-#define TEGRA_GPIO_PN5		109
-#define TEGRA_GPIO_PN6		110
-#define TEGRA_GPIO_PN7		111
-#define TEGRA_GPIO_PO0		112
-#define TEGRA_GPIO_PO1		113
-#define TEGRA_GPIO_PO2		114
-#define TEGRA_GPIO_PO3		115
-#define TEGRA_GPIO_PO4		116
-#define TEGRA_GPIO_PO5		117
-#define TEGRA_GPIO_PO6		118
-#define TEGRA_GPIO_PO7		119
-#define TEGRA_GPIO_PP0		120
-#define TEGRA_GPIO_PP1		121
-#define TEGRA_GPIO_PP2		122
-#define TEGRA_GPIO_PP3		123
-#define TEGRA_GPIO_PP4		124
-#define TEGRA_GPIO_PP5		125
-#define TEGRA_GPIO_PP6		126
-#define TEGRA_GPIO_PP7		127
-#define TEGRA_GPIO_PQ0		128
-#define TEGRA_GPIO_PQ1		129
-#define TEGRA_GPIO_PQ2		130
-#define TEGRA_GPIO_PQ3		131
-#define TEGRA_GPIO_PQ4		132
-#define TEGRA_GPIO_PQ5		133
-#define TEGRA_GPIO_PQ6		134
-#define TEGRA_GPIO_PQ7		135
-#define TEGRA_GPIO_PR0		136
-#define TEGRA_GPIO_PR1		137
-#define TEGRA_GPIO_PR2		138
-#define TEGRA_GPIO_PR3		139
-#define TEGRA_GPIO_PR4		140
-#define TEGRA_GPIO_PR5		141
-#define TEGRA_GPIO_PR6		142
-#define TEGRA_GPIO_PR7		143
-#define TEGRA_GPIO_PS0		144
-#define TEGRA_GPIO_PS1		145
-#define TEGRA_GPIO_PS2		146
-#define TEGRA_GPIO_PS3		147
-#define TEGRA_GPIO_PS4		148
-#define TEGRA_GPIO_PS5		149
-#define TEGRA_GPIO_PS6		150
-#define TEGRA_GPIO_PS7		151
-#define TEGRA_GPIO_PT0		152
-#define TEGRA_GPIO_PT1		153
-#define TEGRA_GPIO_PT2		154
-#define TEGRA_GPIO_PT3		155
-#define TEGRA_GPIO_PT4		156
-#define TEGRA_GPIO_PT5		157
-#define TEGRA_GPIO_PT6		158
-#define TEGRA_GPIO_PT7		159
-#define TEGRA_GPIO_PU0		160
-#define TEGRA_GPIO_PU1		161
-#define TEGRA_GPIO_PU2		162
-#define TEGRA_GPIO_PU3		163
-#define TEGRA_GPIO_PU4		164
-#define TEGRA_GPIO_PU5		165
-#define TEGRA_GPIO_PU6		166
-#define TEGRA_GPIO_PU7		167
-#define TEGRA_GPIO_PV0		168
-#define TEGRA_GPIO_PV1		169
-#define TEGRA_GPIO_PV2		170
-#define TEGRA_GPIO_PV3		171
-#define TEGRA_GPIO_PV4		172
-#define TEGRA_GPIO_PV5		173
-#define TEGRA_GPIO_PV6		174
-#define TEGRA_GPIO_PV7		175
-#define TEGRA_GPIO_PW0		176
-#define TEGRA_GPIO_PW1		177
-#define TEGRA_GPIO_PW2		178
-#define TEGRA_GPIO_PW3		179
-#define TEGRA_GPIO_PW4		180
-#define TEGRA_GPIO_PW5		181
-#define TEGRA_GPIO_PW6		182
-#define TEGRA_GPIO_PW7		183
-#define TEGRA_GPIO_PX0		184
-#define TEGRA_GPIO_PX1		185
-#define TEGRA_GPIO_PX2		186
-#define TEGRA_GPIO_PX3		187
-#define TEGRA_GPIO_PX4		188
-#define TEGRA_GPIO_PX5		189
-#define TEGRA_GPIO_PX6		190
-#define TEGRA_GPIO_PX7		191
-#define TEGRA_GPIO_PY0		192
-#define TEGRA_GPIO_PY1		193
-#define TEGRA_GPIO_PY2		194
-#define TEGRA_GPIO_PY3		195
-#define TEGRA_GPIO_PY4		196
-#define TEGRA_GPIO_PY5		197
-#define TEGRA_GPIO_PY6		198
-#define TEGRA_GPIO_PY7		199
-#define TEGRA_GPIO_PZ0		200
-#define TEGRA_GPIO_PZ1		201
-#define TEGRA_GPIO_PZ2		202
-#define TEGRA_GPIO_PZ3		203
-#define TEGRA_GPIO_PZ4		204
-#define TEGRA_GPIO_PZ5		205
-#define TEGRA_GPIO_PZ6		206
-#define TEGRA_GPIO_PZ7		207
-#define TEGRA_GPIO_PAA0		208
-#define TEGRA_GPIO_PAA1		209
-#define TEGRA_GPIO_PAA2		210
-#define TEGRA_GPIO_PAA3		211
-#define TEGRA_GPIO_PAA4		212
-#define TEGRA_GPIO_PAA5		213
-#define TEGRA_GPIO_PAA6		214
-#define TEGRA_GPIO_PAA7		215
-#define TEGRA_GPIO_PBB0		216
-#define TEGRA_GPIO_PBB1		217
-#define TEGRA_GPIO_PBB2		218
-#define TEGRA_GPIO_PBB3		219
-#define TEGRA_GPIO_PBB4		220
-#define TEGRA_GPIO_PBB5		221
-#define TEGRA_GPIO_PBB6		222
-#define TEGRA_GPIO_PBB7		223
-
-#endif
diff --git a/arch/arm/mach-tegra/include/mach/gpio-tegra.h b/arch/arm/mach-tegra/include/mach/gpio-tegra.h
index 87d37fd..b06b998 100644
--- a/arch/arm/mach-tegra/include/mach/gpio-tegra.h
+++ b/arch/arm/mach-tegra/include/mach/gpio-tegra.h
@@ -23,6 +23,231 @@
 #include <linux/types.h>
 #include <mach/irqs.h>
 
+#define TEGRA_GPIO_PA0		0
+#define TEGRA_GPIO_PA1		1
+#define TEGRA_GPIO_PA2		2
+#define TEGRA_GPIO_PA3		3
+#define TEGRA_GPIO_PA4		4
+#define TEGRA_GPIO_PA5		5
+#define TEGRA_GPIO_PA6		6
+#define TEGRA_GPIO_PA7		7
+#define TEGRA_GPIO_PB0		8
+#define TEGRA_GPIO_PB1		9
+#define TEGRA_GPIO_PB2		10
+#define TEGRA_GPIO_PB3		11
+#define TEGRA_GPIO_PB4		12
+#define TEGRA_GPIO_PB5		13
+#define TEGRA_GPIO_PB6		14
+#define TEGRA_GPIO_PB7		15
+#define TEGRA_GPIO_PC0		16
+#define TEGRA_GPIO_PC1		17
+#define TEGRA_GPIO_PC2		18
+#define TEGRA_GPIO_PC3		19
+#define TEGRA_GPIO_PC4		20
+#define TEGRA_GPIO_PC5		21
+#define TEGRA_GPIO_PC6		22
+#define TEGRA_GPIO_PC7		23
+#define TEGRA_GPIO_PD0		24
+#define TEGRA_GPIO_PD1		25
+#define TEGRA_GPIO_PD2		26
+#define TEGRA_GPIO_PD3		27
+#define TEGRA_GPIO_PD4		28
+#define TEGRA_GPIO_PD5		29
+#define TEGRA_GPIO_PD6		30
+#define TEGRA_GPIO_PD7		31
+#define TEGRA_GPIO_PE0		32
+#define TEGRA_GPIO_PE1		33
+#define TEGRA_GPIO_PE2		34
+#define TEGRA_GPIO_PE3		35
+#define TEGRA_GPIO_PE4		36
+#define TEGRA_GPIO_PE5		37
+#define TEGRA_GPIO_PE6		38
+#define TEGRA_GPIO_PE7		39
+#define TEGRA_GPIO_PF0		40
+#define TEGRA_GPIO_PF1		41
+#define TEGRA_GPIO_PF2		42
+#define TEGRA_GPIO_PF3		43
+#define TEGRA_GPIO_PF4		44
+#define TEGRA_GPIO_PF5		45
+#define TEGRA_GPIO_PF6		46
+#define TEGRA_GPIO_PF7		47
+#define TEGRA_GPIO_PG0		48
+#define TEGRA_GPIO_PG1		49
+#define TEGRA_GPIO_PG2		50
+#define TEGRA_GPIO_PG3		51
+#define TEGRA_GPIO_PG4		52
+#define TEGRA_GPIO_PG5		53
+#define TEGRA_GPIO_PG6		54
+#define TEGRA_GPIO_PG7		55
+#define TEGRA_GPIO_PH0		56
+#define TEGRA_GPIO_PH1		57
+#define TEGRA_GPIO_PH2		58
+#define TEGRA_GPIO_PH3		59
+#define TEGRA_GPIO_PH4		60
+#define TEGRA_GPIO_PH5		61
+#define TEGRA_GPIO_PH6		62
+#define TEGRA_GPIO_PH7		63
+#define TEGRA_GPIO_PI0		64
+#define TEGRA_GPIO_PI1		65
+#define TEGRA_GPIO_PI2		66
+#define TEGRA_GPIO_PI3		67
+#define TEGRA_GPIO_PI4		68
+#define TEGRA_GPIO_PI5		69
+#define TEGRA_GPIO_PI6		70
+#define TEGRA_GPIO_PI7		71
+#define TEGRA_GPIO_PJ0		72
+#define TEGRA_GPIO_PJ1		73
+#define TEGRA_GPIO_PJ2		74
+#define TEGRA_GPIO_PJ3		75
+#define TEGRA_GPIO_PJ4		76
+#define TEGRA_GPIO_PJ5		77
+#define TEGRA_GPIO_PJ6		78
+#define TEGRA_GPIO_PJ7		79
+#define TEGRA_GPIO_PK0		80
+#define TEGRA_GPIO_PK1		81
+#define TEGRA_GPIO_PK2		82
+#define TEGRA_GPIO_PK3		83
+#define TEGRA_GPIO_PK4		84
+#define TEGRA_GPIO_PK5		85
+#define TEGRA_GPIO_PK6		86
+#define TEGRA_GPIO_PK7		87
+#define TEGRA_GPIO_PL0		88
+#define TEGRA_GPIO_PL1		89
+#define TEGRA_GPIO_PL2		90
+#define TEGRA_GPIO_PL3		91
+#define TEGRA_GPIO_PL4		92
+#define TEGRA_GPIO_PL5		93
+#define TEGRA_GPIO_PL6		94
+#define TEGRA_GPIO_PL7		95
+#define TEGRA_GPIO_PM0		96
+#define TEGRA_GPIO_PM1		97
+#define TEGRA_GPIO_PM2		98
+#define TEGRA_GPIO_PM3		99
+#define TEGRA_GPIO_PM4		100
+#define TEGRA_GPIO_PM5		101
+#define TEGRA_GPIO_PM6		102
+#define TEGRA_GPIO_PM7		103
+#define TEGRA_GPIO_PN0		104
+#define TEGRA_GPIO_PN1		105
+#define TEGRA_GPIO_PN2		106
+#define TEGRA_GPIO_PN3		107
+#define TEGRA_GPIO_PN4		108
+#define TEGRA_GPIO_PN5		109
+#define TEGRA_GPIO_PN6		110
+#define TEGRA_GPIO_PN7		111
+#define TEGRA_GPIO_PO0		112
+#define TEGRA_GPIO_PO1		113
+#define TEGRA_GPIO_PO2		114
+#define TEGRA_GPIO_PO3		115
+#define TEGRA_GPIO_PO4		116
+#define TEGRA_GPIO_PO5		117
+#define TEGRA_GPIO_PO6		118
+#define TEGRA_GPIO_PO7		119
+#define TEGRA_GPIO_PP0		120
+#define TEGRA_GPIO_PP1		121
+#define TEGRA_GPIO_PP2		122
+#define TEGRA_GPIO_PP3		123
+#define TEGRA_GPIO_PP4		124
+#define TEGRA_GPIO_PP5		125
+#define TEGRA_GPIO_PP6		126
+#define TEGRA_GPIO_PP7		127
+#define TEGRA_GPIO_PQ0		128
+#define TEGRA_GPIO_PQ1		129
+#define TEGRA_GPIO_PQ2		130
+#define TEGRA_GPIO_PQ3		131
+#define TEGRA_GPIO_PQ4		132
+#define TEGRA_GPIO_PQ5		133
+#define TEGRA_GPIO_PQ6		134
+#define TEGRA_GPIO_PQ7		135
+#define TEGRA_GPIO_PR0		136
+#define TEGRA_GPIO_PR1		137
+#define TEGRA_GPIO_PR2		138
+#define TEGRA_GPIO_PR3		139
+#define TEGRA_GPIO_PR4		140
+#define TEGRA_GPIO_PR5		141
+#define TEGRA_GPIO_PR6		142
+#define TEGRA_GPIO_PR7		143
+#define TEGRA_GPIO_PS0		144
+#define TEGRA_GPIO_PS1		145
+#define TEGRA_GPIO_PS2		146
+#define TEGRA_GPIO_PS3		147
+#define TEGRA_GPIO_PS4		148
+#define TEGRA_GPIO_PS5		149
+#define TEGRA_GPIO_PS6		150
+#define TEGRA_GPIO_PS7		151
+#define TEGRA_GPIO_PT0		152
+#define TEGRA_GPIO_PT1		153
+#define TEGRA_GPIO_PT2		154
+#define TEGRA_GPIO_PT3		155
+#define TEGRA_GPIO_PT4		156
+#define TEGRA_GPIO_PT5		157
+#define TEGRA_GPIO_PT6		158
+#define TEGRA_GPIO_PT7		159
+#define TEGRA_GPIO_PU0		160
+#define TEGRA_GPIO_PU1		161
+#define TEGRA_GPIO_PU2		162
+#define TEGRA_GPIO_PU3		163
+#define TEGRA_GPIO_PU4		164
+#define TEGRA_GPIO_PU5		165
+#define TEGRA_GPIO_PU6		166
+#define TEGRA_GPIO_PU7		167
+#define TEGRA_GPIO_PV0		168
+#define TEGRA_GPIO_PV1		169
+#define TEGRA_GPIO_PV2		170
+#define TEGRA_GPIO_PV3		171
+#define TEGRA_GPIO_PV4		172
+#define TEGRA_GPIO_PV5		173
+#define TEGRA_GPIO_PV6		174
+#define TEGRA_GPIO_PV7		175
+#define TEGRA_GPIO_PW0		176
+#define TEGRA_GPIO_PW1		177
+#define TEGRA_GPIO_PW2		178
+#define TEGRA_GPIO_PW3		179
+#define TEGRA_GPIO_PW4		180
+#define TEGRA_GPIO_PW5		181
+#define TEGRA_GPIO_PW6		182
+#define TEGRA_GPIO_PW7		183
+#define TEGRA_GPIO_PX0		184
+#define TEGRA_GPIO_PX1		185
+#define TEGRA_GPIO_PX2		186
+#define TEGRA_GPIO_PX3		187
+#define TEGRA_GPIO_PX4		188
+#define TEGRA_GPIO_PX5		189
+#define TEGRA_GPIO_PX6		190
+#define TEGRA_GPIO_PX7		191
+#define TEGRA_GPIO_PY0		192
+#define TEGRA_GPIO_PY1		193
+#define TEGRA_GPIO_PY2		194
+#define TEGRA_GPIO_PY3		195
+#define TEGRA_GPIO_PY4		196
+#define TEGRA_GPIO_PY5		197
+#define TEGRA_GPIO_PY6		198
+#define TEGRA_GPIO_PY7		199
+#define TEGRA_GPIO_PZ0		200
+#define TEGRA_GPIO_PZ1		201
+#define TEGRA_GPIO_PZ2		202
+#define TEGRA_GPIO_PZ3		203
+#define TEGRA_GPIO_PZ4		204
+#define TEGRA_GPIO_PZ5		205
+#define TEGRA_GPIO_PZ6		206
+#define TEGRA_GPIO_PZ7		207
+#define TEGRA_GPIO_PAA0		208
+#define TEGRA_GPIO_PAA1		209
+#define TEGRA_GPIO_PAA2		210
+#define TEGRA_GPIO_PAA3		211
+#define TEGRA_GPIO_PAA4		212
+#define TEGRA_GPIO_PAA5		213
+#define TEGRA_GPIO_PAA6		214
+#define TEGRA_GPIO_PAA7		215
+#define TEGRA_GPIO_PBB0		216
+#define TEGRA_GPIO_PBB1		217
+#define TEGRA_GPIO_PBB2		218
+#define TEGRA_GPIO_PBB3		219
+#define TEGRA_GPIO_PBB4		220
+#define TEGRA_GPIO_PBB5		221
+#define TEGRA_GPIO_PBB6		222
+#define TEGRA_GPIO_PBB7		223
+
 #define TEGRA_NR_GPIOS		INT_GPIO_NR
 
 #define TEGRA_GPIO_TO_IRQ(gpio) (INT_GPIO_BASE + (gpio))
-- 
1.7.0.4

