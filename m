Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab1CWPZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:25:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59443 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab1CWPZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZErERUIFAbfhucYsQxfoNi+sCTQIhbUImLJeawdIy6I0/u8ZZHgrnJLuQnkgYXxMub
         MSTqT8wbZ6SsYagk3+pz66bdbojZ6XfUpRv/8C/ImzWcEPMO07o134AY89njsjB8x9PG
         7K/lm2MOAZLPAg2f/rg8OrOifnIc+hKEXNrJM=
MIME-Version: 1.0
In-Reply-To: <20110323073313.GB3731@gmail.com>
References: <20110323073313.GB3731@gmail.com>
Date: Wed, 23 Mar 2011 11:25:35 -0400
Message-ID: <AANLkTi=ug41cCwcc0ukxaDQ+DyVrD9P6u=ytbc9Q5+ya@mail.gmail.com>
Subject: Re: [PATCH]Cleanup some comments style for scripts/kconfig/gconf.c
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        zippel@linux-m68k.org, greg@kroah.com, akpm@linux-foundation.org,
        rdunlap@xenotime.net, joe@perches.com
Cc: Harry Wei <jiaweiwei.xiyou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 23, 2011 at 3:33 AM, Harry Wei <jiaweiwei.xiyou@gmail.com> wrote:
> Hi us,
>        I know we should give annotations with the '/*...*/'
> style. But i see many '//' in scripts/kconfig/gconf.c. So i
> patch for them. However, when i use the command './scripts/checkpatch.pl'
> for my patch, it shows like these:
>
> ERROR: do not initialise globals to 0 or NULL
> #25: FILE: scripts/kconfig/gconf.c:45:
> +GtkWidget *tree1_w = NULL;     /* left  frame */
> ERROR: do not initialise globals to 0 or NULL
> #26: FILE: scripts/kconfig/gconf.c:46:
> +GtkWidget *tree2_w = NULL;     /* right frame */
> ERROR: space required after that ',' (ctx:VxV)
> #82: FILE: scripts/kconfig/gconf.c:950:
> +#if GTK_CHECK_VERSION(2,1,4) /* bug in ctree with earlier version of GTK */
> ERROR: space required after that ',' (ctx:VxV)
> #82: FILE: scripts/kconfig/gconf.c:950:
> +#if GTK_CHECK_VERSION(2,1,4) /* bug in ctree with earlier version of GTK */
> WARNING: line over 80 characters
> #100: FILE: scripts/kconfig/gconf.c:1150:
> +       if (sym_is_choice(sym)) {       /* parse childs for getting final value */
> WARNING: line over 80 characters
> #118: FILE: scripts/kconfig/gconf.c:1360:
>                 +                      if (gtktree_iter_find_node(dst, menu1) == NULL) {       /* add node */
>
> total: 4 errors, 2 warnings, 136 lines checked
>
>        If i should also patch for above errors and warnings?
> Can anyone give me some advice? Thanks in advance.
>
Well, find some interesting project, add features, fix bugs. Yes,
that's more time consuming that this kind of low-hanging fruit.

I start to understand why some considers running checkpatch.pl on
already committed stuff for years as an abomination... This is
especially true when trying to go back in the history of the
file/line, "oh, frak, another useless change". I guess a great git
feature would be to ignore commit made by some people, or commit above
a given SNR, so that the history would not be polluted with crap.

 - Arnaud

> My patch is like following.
>
> Thanks.
> Best Regards.
> Harry Wei.
>
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  scripts/kconfig/gconf.c |   40 ++++++++++++++++++++--------------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
> index 56da945..3966efc 100644
> --- a/scripts/kconfig/gconf.c
> +++ b/scripts/kconfig/gconf.c
> @@ -24,7 +24,7 @@
>  #include <time.h>
>  #include <stdlib.h>
>
> -//#define DEBUG
> +/* #define DEBUG */
>
>  enum {
>        SINGLE_VIEW, SPLIT_VIEW, FULL_VIEW
> @@ -42,8 +42,8 @@ static gboolean resizeable = FALSE;
>  static int opt_mode = OPT_NORMAL;
>
>  GtkWidget *main_wnd = NULL;
> -GtkWidget *tree1_w = NULL;     // left  frame
> -GtkWidget *tree2_w = NULL;     // right frame
> +GtkWidget *tree1_w = NULL;     /* left  frame */
> +GtkWidget *tree2_w = NULL;     /* right frame */
>  GtkWidget *text_w = NULL;
>  GtkWidget *hpaned = NULL;
>  GtkWidget *vpaned = NULL;
> @@ -59,8 +59,8 @@ GtkTreeModel *model1, *model2;
>  static GtkTreeIter *parents[256];
>  static gint indent;
>
> -static struct menu *current; // current node for SINGLE view
> -static struct menu *browsed; // browsed node for SPLIT view
> +static struct menu *current; /* current node for SINGLE view */
> +static struct menu *browsed; /* browsed node for SPLIT view */
>
>  enum {
>        COL_OPTION, COL_NAME, COL_NO, COL_MOD, COL_YES, COL_VALUE,
> @@ -206,7 +206,7 @@ void init_main_window(const gchar * glade_file)
>                                          "weight", PANGO_WEIGHT_BOLD,
>                                          NULL);
>        tag2 = gtk_text_buffer_create_tag(txtbuf, "mytag2",
> -                                         /*"style", PANGO_STYLE_OBLIQUE, */
> +                                         /* "style", PANGO_STYLE_OBLIQUE, */
>                                          NULL);
>
>        gtk_window_set_title(GTK_WINDOW(main_wnd), rootmenu.prompt->text);
> @@ -320,7 +320,7 @@ void init_right_tree(void)
>                                            "inconsistent", COL_BTNINC,
>                                            "visible", COL_BTNVIS,
>                                            "radio", COL_BTNRAD, NULL);
> -       /*g_signal_connect(G_OBJECT(renderer), "toggled",
> +       /* g_signal_connect(G_OBJECT(renderer), "toggled",
>           G_CALLBACK(renderer_toggled), NULL); */
>        renderer = gtk_cell_renderer_text_new();
>        gtk_tree_view_column_pack_start(GTK_TREE_VIEW_COLUMN(column),
> @@ -864,7 +864,7 @@ static void change_sym_value(struct menu *menu, gint col)
>                        display_list();
>                }
>                else if (view_mode == SINGLE_VIEW)
> -                       display_tree_part();    //fixme: keep exp/coll
> +                       display_tree_part();    /* fixme: keep exp/coll */
>                break;
>        case S_INT:
>        case S_HEX:
> @@ -887,7 +887,7 @@ static void toggle_sym_value(struct menu *menu)
>                display_list();
>        }
>        else if (view_mode == SINGLE_VIEW)
> -               display_tree_part();    //fixme: keep exp/coll
> +               display_tree_part();    /* fixme: keep exp/coll */
>  }
>
>  static void renderer_toggled(GtkCellRendererToggle * cell,
> @@ -947,7 +947,7 @@ on_treeview2_button_press_event(GtkWidget * widget,
>        struct menu *menu;
>        gint col;
>
> -#if GTK_CHECK_VERSION(2,1,4) // bug in ctree with earlier version of GTK
> +#if GTK_CHECK_VERSION(2,1,4) /* bug in ctree with earlier version of GTK */
>        gint tx = (gint) event->x;
>        gint ty = (gint) event->y;
>        gint cx, cy;
> @@ -970,7 +970,7 @@ on_treeview2_button_press_event(GtkWidget * widget,
>                ptype = menu->prompt ? menu->prompt->type : P_UNKNOWN;
>
>                if (ptype == P_MENU && view_mode != FULL_VIEW && col == COL_OPTION) {
> -                       // goes down into menu
> +                       /* goes down into menu */
>                        current = menu;
>                        display_tree_part();
>                        gtk_widget_set_sensitive(back_btn, TRUE);
> @@ -1147,7 +1147,7 @@ static gchar **fill_row(struct menu *menu)
>        sym_calc_value(sym);
>        sym->flags &= ~SYMBOL_CHANGED;
>
> -       if (sym_is_choice(sym)) {       // parse childs for getting final value
> +       if (sym_is_choice(sym)) {       /* parse childs for getting final value */
>                struct menu *child;
>                struct symbol *def_sym = sym_get_choice_value(sym);
>                struct menu *def_menu = NULL;
> @@ -1330,7 +1330,7 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
>                        gtk_tree_model_get(model2, child2, COL_MENU,
>                                           &menu2, -1);
>                else
> -                       menu2 = NULL;   // force adding of a first child
> +                       menu2 = NULL;   /* force adding of a first child */
>
>  #ifdef DEBUG
>                printf("%*c%s | %s\n", indent, ' ',
> @@ -1357,7 +1357,7 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
>                }
>
>                if (menu1 != menu2) {
> -                       if (gtktree_iter_find_node(dst, menu1) == NULL) {       // add node
> +                       if (gtktree_iter_find_node(dst, menu1) == NULL) {       /* add node */
>                                if (!valid && !menu2)
>                                        sibling = NULL;
>                                else
> @@ -1368,15 +1368,15 @@ static void update_tree(struct menu *src, GtkTreeIter * dst)
>                                set_node(child2, menu1, fill_row(menu1));
>                                if (menu2 == NULL)
>                                        valid = TRUE;
> -                       } else {        // remove node
> +                       } else {        /* remove node */
>                                memcpy(&tmp, child2, sizeof(GtkTreeIter));
>                                valid = gtk_tree_model_iter_next(model2,
>                                                                 child2);
>                                gtk_tree_store_remove(tree2, &tmp);
>                                if (!valid)
> -                                       return; // next parent
> +                                       return; /* next parent */
>                                else
> -                                       goto reparse;   // next child
> +                                       goto reparse;   /* next child */
>                        }
>                } else if (sym && (sym->flags & SYMBOL_CHANGED)) {
>                        set_node(child2, menu1, fill_row(menu1));
> @@ -1515,8 +1515,8 @@ int main(int ac, char *av[])
>        gtk_init(&ac, &av);
>        glade_init();
>
> -       //add_pixmap_directory (PACKAGE_DATA_DIR "/" PACKAGE "/pixmaps");
> -       //add_pixmap_directory (PACKAGE_SOURCE_DIR "/pixmaps");
> +       /* add_pixmap_directory (PACKAGE_DATA_DIR "/" PACKAGE "/pixmaps"); */
> +       /* add_pixmap_directory (PACKAGE_SOURCE_DIR "/pixmaps"); */
>
>        /* Determine GUI path */
>        env = getenv(SRCTREE);
> @@ -1531,7 +1531,7 @@ int main(int ac, char *av[])
>        if (ac > 1 && av[1][0] == '-') {
>                switch (av[1][1]) {
>                case 'a':
> -                       //showAll = 1;
> +                       /* showAll = 1; */
>                        break;
>                case 'h':
>                case '?':
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
