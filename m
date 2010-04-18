Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0DRImX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 04:42:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46673 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab0DRImV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 04:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qNWbEFzhvGg+o6PfAdyJRUzHA9XP9ChYeh37swjDxT9y3rgLZdjRUpAi7Vs1w6r84Z
         FVBNr0VXjpPY0RJ1A8u6EO0IMJfBxtZSma+9SRIscNIlY7p9uAkQCQnwIzKQJ19eWvNU
         r1o8llwhMWybante7/BnuSr8d/lhA3nDpvjMI=
From: Farid Hammane <farid.hammane@gmail.com>
To: khali@linux-fr.org
Cc: ben-linux@fluff.org, w.sang@pengutronix.de, giometti@linux.it,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Farid Hammane <farid.hammane@gmail.com>
Subject: [PATCH] i2c-core: fix some coding style issues in i2c-core.c
Date: Sun, 18 Apr 2010 10:41:07 +0200
Message-Id: <1271580067-13619-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the i2c-core.c file that fixes up coding style issues found by the checkpatch.pl tool

Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
---
 drivers/i2c/i2c-core.c |   86 ++++++++++++++++++++++++------------------------
 1 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 3202a86..582a53c 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1187,10 +1187,10 @@ EXPORT_SYMBOL(i2c_transfer);
  *
  * Returns negative errno, or else the number of bytes written.
  */
-int i2c_master_send(struct i2c_client *client,const char *buf ,int count)
+int i2c_master_send(struct i2c_client *client, const char *buf, int count)
 {
 	int ret;
-	struct i2c_adapter *adap=client->adapter;
+	struct i2c_adapter *adap = client->adapter;
 	struct i2c_msg msg;

 	msg.addr = client->addr;
@@ -1214,9 +1214,9 @@ EXPORT_SYMBOL(i2c_master_send);
  *
  * Returns negative errno, or else the number of bytes read.
  */
-int i2c_master_recv(struct i2c_client *client, char *buf ,int count)
+int i2c_master_recv(struct i2c_client *client, char *buf, int count)
 {
-	struct i2c_adapter *adap=client->adapter;
+	struct i2c_adapter *adap = client->adapter;
 	struct i2c_msg msg;
 	int ret;

@@ -1407,7 +1407,7 @@ i2c_new_probed_device(struct i2c_adapter *adap,
 }
 EXPORT_SYMBOL_GPL(i2c_new_probed_device);

-struct i2c_adapter* i2c_get_adapter(int id)
+struct i2c_adapter *i2c_get_adapter(int id)
 {
 	struct i2c_adapter *adapter;

@@ -1434,7 +1434,7 @@ static u8 crc8(u16 data)
 {
 	int i;

-	for(i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++) {
 		if (data & 0x8000)
 			data = data ^ POLY;
 		data = data << 1;
@@ -1447,7 +1447,7 @@ static u8 i2c_smbus_pec(u8 crc, u8 *p, size_t count)
 {
 	int i;

-	for(i = 0; i < count; i++)
+	for (i = 0; i < count; i++)
 		crc = crc8((crc ^ p[i]) << 8);
 	return crc;
 }
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL(i2c_smbus_read_byte);
  */
 s32 i2c_smbus_write_byte(struct i2c_client *client, u8 value)
 {
-	return i2c_smbus_xfer(client->adapter,client->addr,client->flags,
+	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
 	                      I2C_SMBUS_WRITE, value, I2C_SMBUS_BYTE, NULL);
 }
 EXPORT_SYMBOL(i2c_smbus_write_byte);
@@ -1555,9 +1555,9 @@ s32 i2c_smbus_write_byte_data(struct i2c_client *client, u8 command, u8 value)
 {
 	union i2c_smbus_data data;
 	data.byte = value;
-	return i2c_smbus_xfer(client->adapter,client->addr,client->flags,
-	                      I2C_SMBUS_WRITE,command,
-	                      I2C_SMBUS_BYTE_DATA,&data);
+	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
+	                      I2C_SMBUS_WRITE, command,
+	                      I2C_SMBUS_BYTE_DATA, &data);
 }
 EXPORT_SYMBOL(i2c_smbus_write_byte_data);

@@ -1594,9 +1594,9 @@ s32 i2c_smbus_write_word_data(struct i2c_client *client, u8 command, u16 value)
 {
 	union i2c_smbus_data data;
 	data.word = value;
-	return i2c_smbus_xfer(client->adapter,client->addr,client->flags,
-	                      I2C_SMBUS_WRITE,command,
-	                      I2C_SMBUS_WORD_DATA,&data);
+	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
+	                      I2C_SMBUS_WRITE, command,
+	                      I2C_SMBUS_WORD_DATA, &data);
 }
 EXPORT_SYMBOL(i2c_smbus_write_word_data);

@@ -1673,9 +1673,9 @@ s32 i2c_smbus_write_block_data(struct i2c_client *client, u8 command,
 		length = I2C_SMBUS_BLOCK_MAX;
 	data.block[0] = length;
 	memcpy(&data.block[1], values, length);
-	return i2c_smbus_xfer(client->adapter,client->addr,client->flags,
-			      I2C_SMBUS_WRITE,command,
-			      I2C_SMBUS_BLOCK_DATA,&data);
+	return i2c_smbus_xfer(client->adapter, client->addr, client->flags,
+			      I2C_SMBUS_WRITE, command,
+			      I2C_SMBUS_BLOCK_DATA, &data);
 }
 EXPORT_SYMBOL(i2c_smbus_write_block_data);

@@ -1717,10 +1717,10 @@ EXPORT_SYMBOL(i2c_smbus_write_i2c_block_data);

 /* Simulate a SMBus command using the i2c protocol
    No checking of parameters is done!  */
-static s32 i2c_smbus_xfer_emulated(struct i2c_adapter * adapter, u16 addr,
+static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
                                    unsigned short flags,
                                    char read_write, u8 command, int size,
-                                   union i2c_smbus_data * data)
+                                   union i2c_smbus_data *data)
 {
 	/* So we need to generate a series of msgs. In the case of writing, we
 	  need to use only one message; when reading, we need two. We initialize
@@ -1728,7 +1728,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter * adapter, u16 addr,
 	  simpler. */
 	unsigned char msgbuf0[I2C_SMBUS_BLOCK_MAX+3];
 	unsigned char msgbuf1[I2C_SMBUS_BLOCK_MAX+2];
-	int num = read_write == I2C_SMBUS_READ?2:1;
+	int num = read_write == I2C_SMBUS_READ ? 2 : 1;
 	struct i2c_msg msg[2] = { { addr, flags, 1, msgbuf0 },
 	                          { addr, flags | I2C_M_RD, 0, msgbuf1 }
 	                        };
@@ -1737,7 +1737,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter * adapter, u16 addr,
 	int status;

 	msgbuf0[0] = command;
-	switch(size) {
+	switch (size) {
 	case I2C_SMBUS_QUICK:
 		msg[0].len = 0;
 		/* Special case: The read/write field is used as data */
@@ -1764,7 +1764,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter * adapter, u16 addr,
 		if (read_write == I2C_SMBUS_READ)
 			msg[1].len = 2;
 		else {
-			msg[0].len=3;
+			msg[0].len = 3;
 			msgbuf0[1] = data->word & 0xff;
 			msgbuf0[2] = data->word >> 8;
 		}
@@ -1857,26 +1857,26 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter * adapter, u16 addr,
 	}

 	if (read_write == I2C_SMBUS_READ)
-		switch(size) {
-			case I2C_SMBUS_BYTE:
-				data->byte = msgbuf0[0];
-				break;
-			case I2C_SMBUS_BYTE_DATA:
-				data->byte = msgbuf1[0];
-				break;
-			case I2C_SMBUS_WORD_DATA:
-			case I2C_SMBUS_PROC_CALL:
-				data->word = msgbuf1[0] | (msgbuf1[1] << 8);
-				break;
-			case I2C_SMBUS_I2C_BLOCK_DATA:
-				for (i = 0; i < data->block[0]; i++)
-					data->block[i+1] = msgbuf1[i];
-				break;
-			case I2C_SMBUS_BLOCK_DATA:
-			case I2C_SMBUS_BLOCK_PROC_CALL:
-				for (i = 0; i < msgbuf1[0] + 1; i++)
-					data->block[i] = msgbuf1[i];
-				break;
+		switch (size) {
+		case I2C_SMBUS_BYTE:
+			data->byte = msgbuf0[0];
+			break;
+		case I2C_SMBUS_BYTE_DATA:
+			data->byte = msgbuf1[0];
+			break;
+		case I2C_SMBUS_WORD_DATA:
+		case I2C_SMBUS_PROC_CALL:
+			data->word = msgbuf1[0] | (msgbuf1[1] << 8);
+			break;
+		case I2C_SMBUS_I2C_BLOCK_DATA:
+			for (i = 0; i < data->block[0]; i++)
+				data->block[i+1] = msgbuf1[i];
+			break;
+		case I2C_SMBUS_BLOCK_DATA:
+		case I2C_SMBUS_BLOCK_PROC_CALL:
+			for (i = 0; i < msgbuf1[0] + 1; i++)
+				data->block[i] = msgbuf1[i];
+			break;
 		}
 	return 0;
 }
@@ -1921,7 +1921,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 		}
 		rt_mutex_unlock(&adapter->bus_lock);
 	} else
-		res = i2c_smbus_xfer_emulated(adapter,addr,flags,read_write,
+		res = i2c_smbus_xfer_emulated(adapter, addr, flags, read_write,
 					      command, protocol, data);

 	return res;
--
1.7.0

