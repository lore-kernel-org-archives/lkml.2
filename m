Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2EGJE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:04:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60733 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755938Ab2EGJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:03:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/7] mfd: wm831x: Fix register range passing for recent ARM updates
Date: Mon,  7 May 2012 10:03:20 +0100
Message-Id: <1336381403-7840-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336381403-7840-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The removal of mach/io.h from most ARM platforms also set the range of
valid IO ports to be empty for most platforms when previously any 32
bit integer had been valid. This makes it impossible to add IO resources
as the added range is smaller than that of the root resource for IO ports.

Since we're not really using IO memory at all fix this by defining our
own root resource outside the normal tree and make that the parent of
all IO resources. This also ensures we won't conflict with read IO ports
if we ever run on a platform which happens to use them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 838056c..476e4d3 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -614,8 +614,15 @@ int wm831x_set_bits(struct wm831x *wm831x, unsigned short reg,
 }
 EXPORT_SYMBOL_GPL(wm831x_set_bits);
 
+static struct resource wm831x_io_parent = {
+	.start = 0,
+	.end   = 0xffffffff,
+	.flags = IORESOURCE_IO,
+};
+
 static struct resource wm831x_dcdc1_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_DC1_CONTROL_1,
 		.end   = WM831X_DC1_DVS_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -637,6 +644,7 @@ static struct resource wm831x_dcdc1_resources[] = {
 
 static struct resource wm831x_dcdc2_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_DC2_CONTROL_1,
 		.end   = WM831X_DC2_DVS_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -657,6 +665,7 @@ static struct resource wm831x_dcdc2_resources[] = {
 
 static struct resource wm831x_dcdc3_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_DC3_CONTROL_1,
 		.end   = WM831X_DC3_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -671,6 +680,7 @@ static struct resource wm831x_dcdc3_resources[] = {
 
 static struct resource wm831x_dcdc4_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_DC4_CONTROL,
 		.end   = WM831X_DC4_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -685,6 +695,7 @@ static struct resource wm831x_dcdc4_resources[] = {
 
 static struct resource wm8320_dcdc4_buck_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_DC4_CONTROL,
 		.end   = WM832X_DC4_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -707,6 +718,7 @@ static struct resource wm831x_gpio_resources[] = {
 
 static struct resource wm831x_isink1_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_CURRENT_SINK_1,
 		.end   = WM831X_CURRENT_SINK_1,
 		.flags = IORESOURCE_IO,
@@ -720,6 +732,7 @@ static struct resource wm831x_isink1_resources[] = {
 
 static struct resource wm831x_isink2_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_CURRENT_SINK_2,
 		.end   = WM831X_CURRENT_SINK_2,
 		.flags = IORESOURCE_IO,
@@ -733,6 +746,7 @@ static struct resource wm831x_isink2_resources[] = {
 
 static struct resource wm831x_ldo1_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO1_CONTROL,
 		.end   = WM831X_LDO1_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -747,6 +761,7 @@ static struct resource wm831x_ldo1_resources[] = {
 
 static struct resource wm831x_ldo2_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO2_CONTROL,
 		.end   = WM831X_LDO2_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -761,6 +776,7 @@ static struct resource wm831x_ldo2_resources[] = {
 
 static struct resource wm831x_ldo3_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO3_CONTROL,
 		.end   = WM831X_LDO3_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -775,6 +791,7 @@ static struct resource wm831x_ldo3_resources[] = {
 
 static struct resource wm831x_ldo4_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO4_CONTROL,
 		.end   = WM831X_LDO4_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -789,6 +806,7 @@ static struct resource wm831x_ldo4_resources[] = {
 
 static struct resource wm831x_ldo5_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO5_CONTROL,
 		.end   = WM831X_LDO5_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -803,6 +821,7 @@ static struct resource wm831x_ldo5_resources[] = {
 
 static struct resource wm831x_ldo6_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO6_CONTROL,
 		.end   = WM831X_LDO6_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -817,6 +836,7 @@ static struct resource wm831x_ldo6_resources[] = {
 
 static struct resource wm831x_ldo7_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO7_CONTROL,
 		.end   = WM831X_LDO7_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -831,6 +851,7 @@ static struct resource wm831x_ldo7_resources[] = {
 
 static struct resource wm831x_ldo8_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO8_CONTROL,
 		.end   = WM831X_LDO8_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -845,6 +866,7 @@ static struct resource wm831x_ldo8_resources[] = {
 
 static struct resource wm831x_ldo9_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO9_CONTROL,
 		.end   = WM831X_LDO9_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -859,6 +881,7 @@ static struct resource wm831x_ldo9_resources[] = {
 
 static struct resource wm831x_ldo10_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO10_CONTROL,
 		.end   = WM831X_LDO10_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -873,6 +896,7 @@ static struct resource wm831x_ldo10_resources[] = {
 
 static struct resource wm831x_ldo11_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_LDO11_ON_CONTROL,
 		.end   = WM831X_LDO11_SLEEP_CONTROL,
 		.flags = IORESOURCE_IO,
@@ -974,6 +998,7 @@ static struct resource wm831x_rtc_resources[] = {
 
 static struct resource wm831x_status1_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_STATUS_LED_1,
 		.end   = WM831X_STATUS_LED_1,
 		.flags = IORESOURCE_IO,
@@ -982,6 +1007,7 @@ static struct resource wm831x_status1_resources[] = {
 
 static struct resource wm831x_status2_resources[] = {
 	{
+		.parent = &wm831x_io_parent,
 		.start = WM831X_STATUS_LED_2,
 		.end   = WM831X_STATUS_LED_2,
 		.flags = IORESOURCE_IO,
-- 
1.7.10

