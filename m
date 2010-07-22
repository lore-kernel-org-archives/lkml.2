Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0GVQ6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:58:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54636 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0GVQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=G2szKTtlBZMltANZHHpL9i9XJtH8biN4xsf1CzyJ0B+ILTEbC8lx4zCW/W7M6zvWlW
         dg4K29jwOgte1YDrGgcdNzUOFMoWnC0VmzJQkWUoYmKTtgau5+RVsgs52JwdR+P4Hw4D
         u0DFfk8B/I1spENd3k1iuVYtlM4lcEjp703tA=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 4/5] staging: wlags49_h2: remove custom hex_to_bin() method
Date: Thu, 22 Jul 2010 19:57:10 +0300
Message-Id: <7883b14b2ed114597ba274df4ffc60fa2a51a7d4.1279817399.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <20100722151545.GA6696@suse.de>
References: <20100722151545.GA6696@suse.de>
In-Reply-To: <cover.1279817399.git.andy.shevchenko@gmail.com>
References: <cover.1279817399.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/wlags49_h2/wl_util.c |   37 +---------------------------------
 drivers/staging/wlags49_h2/wl_util.h |    2 -
 2 files changed, 1 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index bbdb997..ce8ed41 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -259,41 +259,6 @@ int is_valid_key_string( char *s )
 
 
 /*******************************************************************************
- *	hexdigit2int()
- *******************************************************************************
- *
- *  DESCRIPTION:
- *
- *      Converts a hexadecimal digit character to an integer
- *
- *  PARAMETERS:
- *
- *      c   - the hexadecimal digit character
- *
- *  RETURNS:
- *
- *      the converted integer
- *
- ******************************************************************************/
-int hexdigit2int( char c )
-{
-   if( c >= '0' && c <= '9' )
-       return c - '0';
-
-   if( c >= 'A' && c <= 'F' )
-       return c - 'A' + 10;
-
-   if( c >= 'a' && c <= 'f' )
-       return c - 'a' + 10;
-
-   return 0;
-} // hexdigit2int
-/*============================================================================*/
-
-
-
-
-/*******************************************************************************
  *	key_string2key()
  *******************************************************************************
  *
@@ -328,7 +293,7 @@ void key_string2key( char *ks, KEY_STRCT *key )
         p = (char *)key->key;
 
         for( i = 2; i < l; i+=2 ) {
-           *p++ = ( hexdigit2int( ks[i] ) << 4 ) + hexdigit2int (ks[i+1] );
+			*p++ = (hex_to_bin(ks[i]) << 4) + hex_to_bin(ks[i+1]);
            n++;
         }
 
diff --git a/drivers/staging/wlags49_h2/wl_util.h b/drivers/staging/wlags49_h2/wl_util.h
index 561e85b..ba537a6 100644
--- a/drivers/staging/wlags49_h2/wl_util.h
+++ b/drivers/staging/wlags49_h2/wl_util.h
@@ -71,8 +71,6 @@ int is_valid_key_string( char *s );
 
 void key_string2key( char *ks, KEY_STRCT *key );
 
-int hexdigit2int( char c );
-
 void wl_hcf_error( struct net_device *dev, int hcfStatus );
 
 void wl_endian_translate_event( ltv_t *pLtv );
-- 
1.7.1.1

